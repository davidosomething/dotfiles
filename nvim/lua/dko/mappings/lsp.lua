local dkomappings = require("dko.mappings")
local shared = require("dko.mappings.shared")

local picker = dkomappings.picker

local M = {}

---@type { [string]: FeatureMapping }
M.features = {
  ["textDocument/codeAction"] = {
    finder_key = "code_action_finder",
    -- gra is default in 0.11, can use either
    shortcut = "<Leader><Leader>",
    providers = {
      default = vim.lsp.buf.code_action, -- uses the vim.ui.select under the hood, which might be fzf or snacks
      fzf = picker("fzf-lua", "lsp_code_actions"),
      ["tiny-code-action"] = function()
        local jsts = require("dko.utils.jsts")
        local opts = vim.list_contains(jsts.fts, vim.bo.filetype)
            and {
              filter = jsts.filter_code_actions,
              sort = jsts.sort_code_actions,
            }
          or {}
        require("tiny-code-action").code_action(opts)
      end,
    },
  },
  ["textDocument/documentLink"] = {
    shortcut = "grl",
    providers = {
      default = function()
        local _, lsplinks = pcall(require, "lsplinks")
        if lsplinks then
          lsplinks.gx()
        else
          vim.notify(
            ("No handler for %s"):format("textDocument/documentLink"),
            vim.log.levels.WARN
          )
        end
      end,
    },
  },
  ["textDocument/hover"] = {
    shortcut = "K",
    providers = {
      default = vim.lsp.buf.hover,
    },
  },
  ["textDocument/inlayHint"] = {
    shortcut = "<Leader>i",
    providers = {
      default = function()
        vim.notify(
          ("Toggling %s"):format("textDocument/inlayHint"),
          vim.log.levels.DEBUG
        )
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }),
          { bufnr = 0 }
        )
      end,
    },
  },
  ["textDocument/declaration"] = {
    shortcut = "gD",
    providers = {
      default = vim.lsp.buf.declaration,
      fzf = picker("fzf-lua", "lsp_declarations"),
      snacks = picker("snacks", "lsp_declarations"),
    },
  },
  ["textDocument/definition"] = {
    shortcut = "gd",
    providers = {
      default = vim.lsp.buf.definition,
      fzf = picker("fzf-lua", "lsp_definitions"),
      snacks = picker("snacks", "lsp_definitions"),
    },
  },
  lsp_definitions_tagfunc = {
    shortcut = "<C-]>",
    providers = {
      default = vim.lsp.buf.definition,
      fzf = picker("fzf-lua", "lsp_definitions"),
      snacks = picker("snacks", "lsp_definitions"),
    },
  },
  ["textDocument/implementation"] = {
    shortcut = "gri",
    providers = {
      default = vim.lsp.buf.implementation,
      fzf = picker("fzf-lua", "lsp_implementations"),
      snacks = picker("snacks", "lsp_implementations"),
    },
  },
  ["textDocument/references"] = {
    shortcut = "grr",
    providers = {
      default = vim.lsp.buf.references,
      fzf = picker("fzf-lua", "lsp_references"),
      snacks = picker("snacks", "lsp_references"),
    },
  },
  ["textDocument/rename"] = {
    shortcut = "grn",
    providers = {
      default = vim.lsp.buf.rename,
    },
  },
  ["textDocument/typeDefinition"] = {
    shortcut = "<Leader>D",
    providers = {
      default = vim.lsp.buf.type_definition,
      fzf = picker("fzf-lua", "lsp_typedefs"),
      snacks = picker("snacks", "lsp_type_definitions"),
    },
  },
}

---List of unbind functions, keyed by "b"..bufnr
---@type table<string, table<'lsp', fun()[]>>
M.bound = {
  lsp = {},
}

---Run all the unbind functions for the bufnr
---@param bufnr number
---@param group 'lsp'
M.unbind_lsp = function(bufnr, group)
  local key = "b" .. bufnr
  for _, unbind in ipairs(M.bound[group][key]) do
    unbind()
  end
  M.bound[group][key] = nil
  vim.b.did_bind_lsp = false
end

--- Maps and captures the returned cleanup function so we can unbind if the lsp
--- is detached.
local function lspmap(modes, lhs, rhs, opts, group)
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
    local provider_key, provider = shared.get_provider(config, group)
    lspmap("n", config.shortcut, provider, {
      buffer = bufnr,
      desc = shared.format_desc(feature, provider_key),
      silent = true,
    }, group)
  end
end

return M
