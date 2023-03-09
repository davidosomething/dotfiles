return {
  command = "ag",
  options = {
    "--hidden",
    "--path-to-ignore " .. require("dko.settings").get("grepper.ignore_file"),
    "--vimgrep",
  },
  format = "%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m",
}
