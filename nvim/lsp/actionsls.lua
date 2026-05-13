local function get_github_token()
  local handle = io.popen("gh auth token 2>/dev/null")
  if not handle then
    return vim.NIL
  end
  local token = handle:read("*a"):gsub("%s+", "")
  handle:close()
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
local function get_repo_info(owner, repo)
  local cmd = string.format(
    "gh repo view %s/%s --json id,owner --template '{{.id}}\t{{.owner.id}}\t{{.owner.type}}' 2>/dev/null",
    owner,
    repo
  )
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end
  local result = handle:read("*a"):gsub("%s+$", "")
  handle:close()

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

local function get_repos_config()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then
    return vim.NIL
  end
  local git_root = handle:read("*a"):gsub("%s+", "")
  handle:close()

  if git_root == "" then
    return vim.NIL
  end

  handle = io.popen("git remote get-url origin 2>/dev/null")
  if not handle then
    return vim.NIL
  end
  local remote_url = handle:read("*a"):gsub("%s+", "")
  handle:close()

  local owner, name = parse_github_remote(remote_url)
  if not owner or not name then
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
    sessionToken = get_github_token(),
    repos = get_repos_config(),
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

return with_nvim_lspconfig_additions
