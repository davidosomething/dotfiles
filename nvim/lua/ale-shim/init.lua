local opts = {
  formatters = {},
}

local M = {}

M.setup = function(config)
  opts = vim.tbl_deep_extend("force", opts, config or {})
end

--- Formatting pipeline, run optional formatter functions
local format = function(linter_name, item)
  local formatted = item.text
  local formatters = opts.formatters[linter_name] or {}
  for _, formatter in ipairs(formatters) do
    formatted = formatter(linter_name, item, formatted)
  end
  return formatted
end

-- Example args
-- { 1, "coctsserver", { {
--       code = 2307,
--       col = 24,
--       end_col = 30,
--       end_lnum = 1,
--       lnum = 1,
--       text = "Cannot find module 'react' or its corresponding type declarations.",
--       type = "E"
--     }, {
--       code = 2353,
--       col = 5,
--       end_col = 9,
--       end_lnum = 15,
--       lnum = 15,
--       text = "Object literal may only specify known properties, and 'third' does not exist in type '{ second: { str: string; int: number; }; }'.",
--       type = "E"
--     }, {
--       code = 2741,
--       col = 7,
--       end_col = 7,
--       end_lnum = 21,
--       lnum = 21,
--       text = "Property 'first' is missing in type '{}' but required in type 'Deep'.",
--       type = "E"
--     }, {
--      ...
--     } } }
M.convert_to_vim_diagnostic = function(buffer, linter_name, loclist)
  local ns = vim.api.nvim_create_namespace(("aleshim--%s"):format(linter_name))
  local diagnostics = {}
  for i, item in ipairs(loclist) do
    diagnostics[i] = {
      -- (`integer`) Buffer number
      bufnr = buffer,
      lnum = item.lnum,
      end_lnum = item.lnum,
      col = item.col,
      end_col = item.end_col,
      severity = vim.diagnostic.severity[item.type],
      message = format(linter_name, item),
      source = linter_name,
      code = item.code,
    }
  end
  vim.diagnostic.set(ns, buffer, diagnostics)
end

return M
