-- neovim supports built-in osc52 as of
--  https://github.com/neovim/neovim/pull/25872/files
-- and it is used if we are on a remote connection by default as of
--  https://github.com/neovim/neovim/pull/26064/files
-- When NOT being used, prefer unnamedplus (system) clipboard
if require("dko.utils.clipboard").should_use_osc52() then
  if vim.g.clipboard then
    -- already using a plugin?
    return
  end
  -- else it should automatically use OSC 52 according to :h clipboard-osc52
  -- BUT for docker exec shells we need to manually enable
  if require("dko.utils.vte").is_docker_exec() then
    vim.g.clipboard = {
      name = "OSC 52 (docker)",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
      },
    }
  end
else
  vim.o.clipboard = "unnamedplus"
end
