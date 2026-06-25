\(pallete : ../themes/Schema.dhall) ->
  { theme = pallete.ghostty
  , font-family = "monospace"
  , font-size = "10"
  , window-decoration = "true"
  , window-save-state = "always"
  , cursor-style = "block"
  , cursor-style-blink = "true"
  , -- command = vim -c "tab terminal nu" -c "1tabclose"
    command = "nu"
  , gtk-titlebar-style = "tabs"
  , confirm-close-surface = "false"
  }
