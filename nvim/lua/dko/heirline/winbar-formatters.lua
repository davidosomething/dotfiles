-- see ../utils/format.lua for vim.b.formatters definition
-- List format-on-save clients for the buffer
return {
  update = {
    "User",
    pattern = "FormattersChanged",
    callback = vim.schedule_wrap(function()
      vim.cmd.redrawstatus({ bang = true })
    end),
  },
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
        local pipelines = require("dko.utils.format").pipelines
        local pipeline = pipelines[vim.bo.filetype] or {}
        if pipeline[2] then
          table.insert(items, pipeline[2])
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
      return "󱃖 "
        .. require("dko.utils.string").smallcaps(table.concat(items, ","))
        .. " "
    end,
  },
}
