return {
  init = function(self)
    local ok, fw = pcall(require, "file-watch")
    self.enabled = ok and fw.status().enabled
  end,
  provider = "  ",
  hl = function(self)
    return self.enabled and "String" or "Error"
  end,
}
