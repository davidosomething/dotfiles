return {
  command = "rg",
  options = {
    "--hidden",
    "--ignore-file " .. require("dko.settings").get("grepper.ignore_file"),
    "--smart-case",
    "--vimgrep",
  },
  format = "%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m",
}
