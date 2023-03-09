return {
  command = "ack",
  options = {
    "--nogroup",
    "--nocolor",
    "--smart-case",
    "--column",
  },
  format = "%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m",
}
