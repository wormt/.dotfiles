# Alacritty config, templated in Nickel. Colors from shared palette.ncl.

let palette = import "palette.ncl" in

let main = {
  shell = "/bin/ash",
  live_config_reload = false,
  ipc_socket = false,

  scrolling = {
    history = 65536,
    multiplier = 0,
  },

  window = {
    opacity = 0.95,
  },

  font = {
    size = 7,
    normal = { family = "Monaco" },
  },

  colors = {
    draw_bold_text_with_bright_colors = true,

    bright = {
      black = palette.bright.black,
      red = palette.bright.red,
      green = palette.bright.green,
      yellow = palette.bright.yellow,
      blue = palette.bright.blue,
      magenta = palette.bright.magenta,
      cyan = palette.bright.cyan,
      white = palette.bright.white,
    },

    normal = {
      black = palette.normal.black,
      red = palette.normal.red,
      green = palette.normal.green,
      yellow = palette.normal.yellow,
      blue = palette.normal.blue,
      magenta = palette.normal.magenta,
      cyan = palette.normal.cyan,
      white = palette.normal.white,
    },

    dim = {
      black = palette.dim.black,
      red = palette.dim.red,
      green = palette.dim.green,
      yellow = palette.dim.yellow,
      blue = palette.dim.blue,
      magenta = palette.dim.magenta,
      cyan = palette.dim.cyan,
      white = palette.dim.white,
    },

    primary = {
      background = palette.background,
      foreground = palette.foreground,
    },
  },
}

in main
