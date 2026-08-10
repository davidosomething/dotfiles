local utils = require("dko.heirline.utils")

return {
  provider = function()
    -- which WezTerm tab this instance is shared with, when tab-scoped
    local tab_id = utils.remote_tab_id()
    return tab_id and (" 󰴽 %s "):format(tab_id) or " 󰴽 "
  end,
  hl = function()
    return utils.is_remote_server() and "String" or "Error"
  end,
}
