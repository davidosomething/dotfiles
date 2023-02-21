return {
  condition = require("heirline.conditions").is_git_repo,
  {
    provider = "  ",
    hl = "dkoStatusKey",
  },
  {
    provider = function()
      return " " .. vim.b["gitsigns_head"] .. " "
    end,
    hl = "dkoStatusValue",
  },
}
