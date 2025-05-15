local smallcaps = require("dko.utils.string").smallcaps

-- see ../utils/format.lua for vim.b.formatters definition
-- List format-on-save clients for the buffer
return {
  condition = function()
    -- nil means NEVER registered
    return vim.b.formatters ~= nil
  end,
  {
    condition = function()
      return #vim.b.formatters == 0
    end,
    provider = " 󱃖 ",
    hl = function()
      -- empty table means probably LspStop happened
      return require("dko.heirline.utils").hl("DiffDelete")
    end,
  },

  {
    condition = function()
      return #vim.b.formatters > 0
    end,
    hl = function()
      return require("dko.heirline.utils").hl()
    end,
    provider = function()
      local items = {}
      if vim.b.formatter then
        table.insert(items, vim.b.formatter)
      else
        local pipelines = require("dko.utils.format").pipelines[vim.bo.filetype]
        if pipelines[2] then
          table.insert(items, pipelines[2])
        else
          for _, name in ipairs(vim.b.formatters) do
            if vim.bo.filetype ~= "" and name == "efm" then
              local efm_keys = vim.tbl_keys(
                require("dko.tools").efm_filetypes[vim.bo.filetype] or {}
              )
              table.insert(
                items,
                ("efm[%s]"):format(table.concat(efm_keys, ","))
              )
            else
              table.insert(items, name)
            end
          end
        end
      end
      return "󱃖 " .. smallcaps(table.concat(items, ",")) .. " "
    end,
  },
}
