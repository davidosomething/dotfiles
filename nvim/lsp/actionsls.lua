-- gh auth token has been observed to block for 60s+ on this host, so gh must
-- never run during startup. The fetch below is deferred until the first
-- yaml.ghactions buffer opens (the only time the server starts) and every gh
-- call is capped at TIMEOUT_MS.
local TIMEOUT_MS = 500

--- Run a command synchronously with a hard timeout.
---@param cmd string[]
---@param timeout_ms integer
---@return { code: integer, stdout: string }
local function run_sync(cmd, timeout_ms)
  return vim.system(cmd, {
    timeout = timeout_ms,
    text = true,
    stderr = false,
  }):wait()
end

---@return string|vim.NIL
local function get_github_token()
  local out = run_sync({ "gh", "auth", "token" }, TIMEOUT_MS)
  if out.code ~= 0 then
    return vim.NIL
  end
  local token = (out.stdout or ""):gsub("%s+", "")
  return token ~= "" and token or vim.NIL
end

local function parse_github_remote(url)
  if not url or url == "" then
    return nil
  end

  -- SSH format: git@github.com:owner/repo.git
  local owner, repo = url:match("git@github%.com:([^/]+)/([^/%.]+)")
  if owner and repo then
    return owner, repo:gsub("%.git$", "")
  end

  -- HTTPS format: https://github.com/owner/repo.git
  owner, repo = url:match("github%.com/([^/]+)/([^/%.]+)")
  if owner and repo then
    return owner, repo:gsub("%.git$", "")
  end

  return nil
end

--- @davidosomething
--- > This is a modified version of what's in https://github.com/actions/languageservices/tree/main/languageserver#3-create-the-lsp-configuration
--- > I added owner.id checking to determine organizationOwned
---@param owner string
---@param repo string
---@return { id: string|integer, organizationOwned: boolean }|nil
local function get_repo_info(owner, repo)
  local out = run_sync({
    "gh",
    "repo",
    "view",
    string.format("%s/%s", owner, repo),
    "--json",
    "id,owner",
    "--template",
    "{{.id}}\t{{.owner.id}}\t{{.owner.type}}",
  }, TIMEOUT_MS)
  if out.code ~= 0 then
    return nil
  end
  local result = (out.stdout or ""):gsub("%s+$", "")

  local id, owner_id, owner_type = result:match("^([^\t]+)\t([^\t]+)\t(.+)$")
  if id then
    return {
      id = tonumber(id) or id,
      organizationOwned = owner_type == "Organization"
        or owner_id:sub(1, 2) == "O_",
    }
  end
  return nil
end

---@return table|vim.NIL
local function get_repos_config()
  local out = run_sync({ "git", "rev-parse", "--show-toplevel" }, TIMEOUT_MS)
  local git_root = (out.stdout or ""):gsub("%s+", "")
  if out.code ~= 0 or git_root == "" then
    return vim.NIL
  end

  out = run_sync({ "git", "remote", "get-url", "origin" }, TIMEOUT_MS)
  local remote_url = (out.stdout or ""):gsub("%s+", "")
  local owner, name = parse_github_remote(remote_url)
  if out.code ~= 0 or not owner or not name then
    return vim.NIL
  end

  local info = get_repo_info(owner, name)

  return {
    {
      id = info and info.id or 0,
      owner = owner,
      name = name,
      organizationOwned = info and info.organizationOwned or false,
      workspaceUri = "file://" .. git_root,
    },
  }
end

--- This is the config suggested by https://github.com/actions/languageservices/tree/main/languageserver#3-create-the-lsp-configuration
--- 1. It has trouble resolving local workflows
--- 2. It enables communication with github to fill in some data
--- @type vim.lsp.Config
local upstream_config = {
  cmd = { "actions-languageserver", "--stdio" },
  filetypes = { "yaml.ghactions" },
  root_markers = { ".git" },
  init_options = {
    -- Optional: provide a GitHub token and repo context for added functionality
    -- (e.g., repository-specific completions)
    -- Filled in the first time a yaml.ghactions buffer opens, see
    -- fetch_github_config()
    sessionToken = vim.NIL,
    repos = vim.NIL,
  },
}

--- Add some overrides that nvim-lspconfig also does
--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/gh_actions_ls.lua
--- @type vim.lsp.Config
local with_nvim_lspconfig_additions = vim.tbl_extend("force", upstream_config, {
  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },

  -- prefer root_dir
  root_markers = nil,

  -- `root_dir` ensures that the LSP does not attach to all yaml files
  root_dir = function(bufnr, on_dir)
    local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    if
      vim.endswith(parent, "/.github/workflows")
      or vim.endswith(parent, "/.forgejo/workflows")
      or vim.endswith(parent, "/.gitea/workflows")
    then
      on_dir(parent)
    end
  end,

  -- given a file:// protocol path as built using the workspaceUri above,
  -- resolve path to disk path and provide filecontents when lsp requests this
  -- action https://github.com/actions/languageservices/blob/main/languageserver/src/request.ts#L2
  handlers = {
    ["actions/readFile"] = function(_, result)
      if type(result.path) ~= "string" then
        return nil, nil
      end
      local file_path = vim.uri_to_fname(result.path)
      if vim.fn.filereadable(file_path) == 1 then
        local f = assert(io.open(file_path, "r"))
        local text = f:read("*a")
        f:close()

        return text, nil
      end
      return nil, nil
    end,
  },
})

--- Fetch the GitHub token and repo context the first time a yaml.ghactions
--- buffer opens and merge them into the registered config. Merging invalidates
--- the resolved config, and this autocmd is registered before nvim's own
--- FileType autocmd (nvim.lsp.enable group) since this file is loadfile'd
--- during vim.lsp.enable(), before that autocmd is created -- so the first
--- client started for this buffer resolves the config with the token already
--- merged in.
---
--- The gh calls are capped at TIMEOUT_MS each, so opening the first workflow
--- file blocks for at most ~1s on a host where gh hangs, and only ~ms when gh
--- responds normally.
local function fetch_github_config()
  if vim.g.dko_actionsls_github_fetched then
    return
  end
  vim.g.dko_actionsls_github_fetched = 1

  vim.lsp.config("actionsls", {
    init_options = {
      sessionToken = get_github_token(),
      repos = get_repos_config(),
    },
  })
end

-- This file is loaded by nvim's vim.lsp.config loader via loadfile(), and
-- re-loaded whenever the config is invalidated and resolved again -- including
-- by the vim.lsp.config() merge above. Only register the trigger once per
-- session.
if not vim.g.dko_actionsls_github_fetched then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml.ghactions",
    callback = fetch_github_config,
  })
end

return with_nvim_lspconfig_additions
