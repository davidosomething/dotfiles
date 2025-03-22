local dkomappings = require("dko.mappings")
local dkoproject = require("dko.utils.project")
local dkosettings = require("dko.settings")

local picker = dkomappings.picker

local M = {}

---@type FeatureMapping[]
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
      -- folke has no plans to implement code_action so fallback to fzf
      -- https://github.com/folke/snacks.nvim/issues/626#issuecomment-2600919588
      default = picker("fzf-lua", "lsp_code_actions"),
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
      snacks = picker("snacks", "smart", {
        multi = { "recent", "buffers" },
      }),
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
  local function map(modes, lhs, rhs, opts)
    opts.silent = true
    opts.remap = true
    dkomappings.map(modes, lhs, rhs, opts)
  end

  for feature, config in pairs(M.features) do
    local provider_key = dkosettings.get("finder")
    provider_key = config.providers[provider_key] and provider_key or "default"
    local provider = config.providers[provider_key]
    if provider then
      map("n", config.shortcut, provider, {
        desc = ("%s [%s]"):format(feature, provider_key),
      })
    end
  end

  --map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --[[ map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts) ]]
end

return M
