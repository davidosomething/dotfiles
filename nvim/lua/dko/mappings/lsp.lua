local dkomappings = require("dko.mappings")
local dkosettings = require("dko.settings")

local picker = dkomappings.picker

local M = {}

---@type FeatureMapping[]
M.features = {
  code_action = {
    finder_key = "code_action_finder",
    -- gra is default in 0.11, can use either
    shortcut = "<Leader><Leader>",
    providers = {
      coc = "<Plug>(coc-codeaction-cursor)",
      default = vim.lsp.buf.code_action, -- uses the vim.ui.select under the hood, which might be fzf or snacks
      fzf = picker("fzf-lua", "lsp_code_actions"),
      ["tiny-code-action"] = function()
        require("tiny-code-action").code_action()
      end,
    },
  },
  documentLink = {
    shortcut = "grl",
    providers = {
      coc = "<Plug>(coc-openlink)",
      default = function()
        require("dko.utils.lsp").follow_documentLink()
      end,
    },
  },
  hover = {
    shortcut = "K",
    providers = {
      coc = function()
        --- enter the hover window or pop one up
        local winids = vim.fn["coc#float#get_float_win_list"]()
        if #winids > 0 then
          vim.fn.win_gotoid(winids[1]) --- 1 indexed !
          return
        end
        if vim.fn.CocAction("hasProvider", "hover") then
          -- Same as doHover but includes definition contents from
          -- definition provider when possible
          vim.fn.CocAction("definitionHover")
          return
        end
        vim.lsp.buf.hover()
      end,
      default = vim.lsp.buf.hover,
    },
  },
  lsp_declarations = {
    shortcut = "gD",
    providers = {
      coc = "<Plug>(coc-declaration)",
      default = vim.lsp.buf.declaration,
      fzf = picker("fzf-lua", "lsp_declarations"),
      snacks = picker("snacks", "lsp_declarations"),
    },
  },
  lsp_definitions = {
    shortcut = "gd",
    providers = {
      coc = "<Plug>(coc-definition)",
      default = vim.lsp.buf.definition,
      fzf = picker("fzf-lua", "lsp_definitions"),
      snacks = picker("snacks", "lsp_definitions"),
    },
  },
  lsp_definitions_tagfunc = {
    shortcut = "<C-]>",
    providers = {
      coc = "<Plug>(coc-definition)",
      default = vim.lsp.buf.definition,
      fzf = picker("fzf-lua", "lsp_definitions"),
      snacks = picker("snacks", "lsp_definitions"),
    },
  },
  lsp_implementations = {
    shortcut = "gri",
    providers = {
      coc = "<Plug>(coc-implementation)",
      default = vim.lsp.buf.implementation,
      fzf = picker("fzf-lua", "lsp_implementations"),
      snacks = picker("snacks", "lsp_implementations"),
    },
  },
  lsp_references = {
    shortcut = "grr",
    providers = {
      coc = "<Plug>(coc-references)",
      default = vim.lsp.buf.references,
      fzf = picker("fzf-lua", "lsp_references"),
      snacks = picker("snacks", "lsp_references"),
    },
  },
  symbol_rename = {
    shortcut = "grn",
    providers = {
      coc = "<Plug>(coc-rename)",
      default = vim.lsp.buf.rename,
    },
  },
  type_definition = {
    shortcut = "<Leader>D",
    providers = {
      coc = "<Plug>(coc-type-definition)",
      default = vim.lsp.buf.type_definition,
      fzf = picker("fzf-lua", "lsp_typedefs"),
      snacks = picker("snacks", "lsp_type_definitions"),
    },
  },
}

---List of unbind functions, keyed by "b"..bufnr
---@type table<string, table<'coc'|'lsp', fun()[]>>
M.bound = {
  lsp = {},
  coc = {},
}

---Run all the unbind functions for the bufnr
---@param bufnr number
---@param group 'coc'|'lsp'
M.unbind_lsp = function(bufnr, group)
  local key = "b" .. bufnr
  for _, unbind in ipairs(M.bound[group][key]) do
    unbind()
  end
  M.bound[group][key] = nil
  vim.b.did_bind_lsp = false
end

---@param config FeatureMapping
---@param group FeatureGroup
---@return FeatureProviderKey,FeatureProvider -- tuple of provider_key and provider config
local function get_provider(config, group)
  if group == "coc" and config.providers["coc"] then
    return "coc", config.providers["coc"]
  end
  local finder_key = config.finder_key or "finder"
  local finder = dkosettings.get(finder_key)
  local provider_key = config.providers[finder] and finder or "default"
  return provider_key, config.providers[provider_key]
end

local function lspmap(modes, lhs, rhs, opts, group)
  opts.silent = true
  local unbind = dkomappings.map(modes, lhs, rhs, opts)
  local key = "b" .. opts.buffer
  M.bound[group][key] = M.bound[group][key] or {}
  table.insert(M.bound[group][key], unbind)
end

---@param bufnr number
---@param group? FeatureGroup
M.bind_lsp = function(bufnr, group)
  if vim.b.did_bind_lsp then -- First LSP attached
    return
  end

  group = group or "lsp"
  vim.b.did_bind_lsp = group

  for feature, config in pairs(M.features) do
    local provider_key, provider = get_provider(config, group)
    lspmap("n", config.shortcut, provider, {
      buffer = bufnr,
      desc = ("%s [%s]"):format(feature, provider_key),
    }, group)
  end

  --map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --[[ map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts) ]]
end

-- =============================================================================
-- Buffer: LSP integration
-- Mix of https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- and :h lsp
-- =============================================================================

-- Bindings for coc.nvim. Conflicts with bind_lsp.
-- opts = {
--   buf = 1,
--   event = "FileType",
--   file = "app/components/Navigation.tsx",
--   id = 26,
--   match = "typescriptreact"
-- }
M.bind_coc = function(opts)
  if vim.b.did_bind_lsp then
    vim.notify(
      "Tried to bind_coc but bind_lsp was already called",
      vim.log.levels.ERROR,
      { title = "[COC]", render = "wrapped-compact" }
    )
    return
  end
  -- make sure bind_lsp doesn't overwrite mappings later
  vim.b.did_bind_coc = true
  M.bind_lsp(opts.buf, "coc")
end

return M
