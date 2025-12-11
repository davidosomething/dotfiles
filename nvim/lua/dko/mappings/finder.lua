local dkomappings = require("dko.mappings")
local dkoproject = require("dko.utils.project")
local shared = require("dko.mappings.shared")

local picker = dkomappings.picker

local Methods = vim.lsp.protocol.Methods

local M = {}

---@type { [string]: FeatureMapping }
M.features = {
  buffers = {
    shortcut = "<A-b>",
    providers = {
      fzf = picker("fzf-lua", "buffers", { current = false }),
      snacks = picker("snacks", "buffers"),
    },
  },
  code_actions = {
    -- This is always for vim.lsp.buf.code_action, never for coc
    -- This way I can access regular lsp code actions alongside coc
    shortcut = "<A-a>",
    providers = {
      -- no snacks one
      -- https://github.com/folke/snacks.nvim/issues/626#issuecomment-2600919588
      -- @TODO use
      default = function()
        local dkolspmappings = require("dko.mappings.lsp")
        local feature = Methods.textDocument_codeAction
        local config = dkolspmappings.features[feature]
        local _, provider = dkolspmappings.get_provider(config, "lsp")
        provider()
      end,
    },
  },
  files = {
    shortcut = "<A-c>",
    providers = {
      fzf = picker("fzf-lua", "files"),
      snacks = picker("snacks", "files"),
    },
  },
  git_files = {
    shortcut = "<A-f>",
    providers = {
      fzf = picker("fzf-lua", "git_files"),
      snacks = picker("snacks", "git_files"),
    },
  },
  git_status = {
    shortcut = "<A-s>",
    providers = {
      fzf = picker("fzf-lua", "git_status"),
      snacks = picker("snacks", "git_status"),
    },
  },
  grep = {
    shortcut = "<A-g>",
    providers = {
      fzf = picker("fzf-lua", "live_grep_resume"),
      snacks = picker("snacks", "grep"),
    },
  },
  mru = {
    shortcut = "<A-m>",
    providers = {
      fzf = picker("fzf-lua", "oldfiles", {
        git_icons = false,
        include_current_session = true,
        stat_file = true, -- verify files exist on disk
      }),
      snacks = picker("snacks", "recent"),
    },
  },
  project = {
    shortcut = "<A-p>",
    providers = {
      fzf = picker("fzf-lua", "files", {
        cwd = dkoproject.root(),
        git_icons = false,
      }),
      snacks = picker("snacks", "files", {
        dirs = { dkoproject.root() },
      }),
    },
  },
  resume = {
    shortcut = "<A-.>",
    providers = {
      fzf = picker("fzf-lua", "resume"),
      snacks = picker("snacks", "resume"),
    },
  },
  vim = {
    shortcut = "<A-v>",
    providers = {
      fzf = picker("fzf-lua", "files", {
        cwd = vim.fn.stdpath("config"),
      }),
      snacks = picker("snacks", "files", {
        dirs = { vim.fn.stdpath("config") },
      }),
    },
  },
}

M.bind_finder = function()
  for feature, config in pairs(M.features) do
    local provider_key, provider = shared.get_provider(config, nil, "finder")
    if provider then
      dkomappings.map("n", config.shortcut, provider, {
        desc = shared.format_desc(feature, provider_key),
        silent = true,
      })
    end
  end
end

return M
