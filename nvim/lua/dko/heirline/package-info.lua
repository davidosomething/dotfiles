return {
  condition = function()
    return vim.api.nvim_buf_get_name(0) == "package.json"
  end,
  update = { "User PackageInfoProgress" },
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
