return {
  provider = function()
    local ok, package_info = pcall(require, "package-info")
    if ok then
      local contents = package_info.get_status()
      return contents:len() > 0 and (" %s "):format(contents) or ""
    end
    return ""
  end,
  hl = "dkoStatusKey",
}
