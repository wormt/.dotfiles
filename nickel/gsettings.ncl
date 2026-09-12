let Integer =
  std.contract.from_predicate (fun x =>
    if std.is_number x then std.number.is_integer x else false
  )
in

let Value = std.contract.any_of [ Bool, Integer, String, Array String ] in

let Section = { path | String, keys | { _ : Value } } in

let escape = fun s =>
  s |> std.string.replace "\\" "\\\\" |> std.string.replace "'" "\\'"
in

let quote = fun s => "'" ++ escape s ++ "'" in

let renderValue
  | Value -> String
  = fun v =>
    if std.is_array v then
      if std.array.length v == 0 then
        "@as []"
      else
        "[" ++ std.string.join ", " (std.array.map quote v) ++ "]"
    else if std.is_bool v then
      (if v then "true" else "false")
    else if std.is_number v then
      std.string.from_number v
    else
      quote v
in

let renderSection
  | Section -> String
  = fun s =>
    let lines =
      std.record.to_array s.keys
      |> std.array.map (fun kv =>
        "%{kv.field}=%{renderValue kv.value}"
      )
    in
    "[" ++ s.path ++ "]\n" ++ std.string.join "\n" lines ++ "\n"
in

let render
  | Array Section -> String
  = fun sections => std.string.join "\n" (std.array.map renderSection sections)
in

let albumwm = {
  path = "org/gnome/shell/extensions/albumwm",
  keys = {
    "column-gap"
      | Integer
      | doc "horizontal space between tiled columns"
      = 8,
    "gesture-enabled"
      | Bool
      | doc "touchpad swipe gestures for panning"
      = true,
    "gesture-horizontal-fingers"
      | Integer
      | doc "fingers for the horizontal pan gesture"
      = 3,
    "horizontal-margin"
      | Integer
      | doc "left/right margin inside the work area"
      = 8,
    "vertical-margin"
      | Integer
      | doc "top/bottom margin inside the work area"
      = 6,
    "warp-pointer-on-focus"
      | Bool
      | doc "warp the pointer onto a window when it gets focus"
      = true,
    "winprops"
      | Array String
      | doc "window property overrides"
      = [],
  },
}
in

let albumwm_keybindings = {
  path = "org/gnome/shell/extensions/albumwm/keybindings",
  keys = {
    "close-window"
      | Array String
      | doc "close the focused window"
      = ["<Shift><Super>q"],
    "cycle-focus-modes"
      | Array String
      | doc "cycle default/center/edge focus mode"
      = [""],
    "cycle-preset-column-width-backwards"
      | Array String
      = ["<Super><Alt>r"],
    "cycle-preset-window-height-backwards"
      | Array String
      = ["<Super><Alt><Shift>r"],
    "dec-column-width"
      | Array String
      | doc "decrease the focused column's width"
      = ["<Shift><Super>braceleft"],
    "dec-window-height"
      | Array String
      | doc "decrease the focused window's height"
      = ["<Shift><Super>underscore"],
    "focus-column-left"
      | Array String
      | doc "focus the column to the left"
      = ["<Super>h"],
    "focus-column-right"
      | Array String
      | doc "focus the column to the right"
      = ["<Super>l"],
    "focus-monitor-above"
      | Array String
      = ["<Alt><Super>k"],
    "focus-monitor-below"
      | Array String
      = ["<Alt><Super>j"],
    "focus-monitor-left"
      | Array String
      = ["<Alt><Super>h"],
    "focus-monitor-right"
      | Array String
      = ["<Alt><Super>l"],
    "focus-window-down"
      | Array String
      | doc "focus the window below"
      = ["<Super>j"],
    "focus-window-up"
      | Array String
      | doc "focus the window above"
      = ["<Super>k"],
    "inc-column-width"
      | Array String
      | doc "increase the focused column's width"
      = ["<Shift><Super>braceright"],
    "move-column-left"
      | Array String
      | doc "move the focused column left"
      = ["<Shift><Super>h"],
    "move-column-right"
      | Array String
      | doc "move the focused column right"
      = ["<Shift><Super>l"],
    "move-window-down"
      | Array String
      | doc "move the focused window down"
      = ["<Shift><Super>j"],
    "move-window-to-monitor-above"
      | Array String
      = ["<Shift><Control><Super>k"],
    "move-window-to-monitor-below"
      | Array String
      = ["<Shift><Control><Super>j"],
    "move-window-to-monitor-left"
      | Array String
      = ["<Shift><Control><Super>h"],
    "move-window-to-monitor-right"
      | Array String
      = ["<Shift><Control><Super>l"],
    "move-window-up"
      | Array String
      | doc "move the focused window up"
      = ["<Shift><Super>k"],
    "switch-focus-between-floating-and-tiling"
      | Array String
      = ["<Super>s"],
    "toggle-window-floating"
      | Array String
      | doc "toggle the focused window floating"
      = ["<Shift><Super>s"],
  },
}
in

let wm_preferences = {
  path = "org/gnome/desktop/wm/preferences",
  keys = {
    "audible-bell"
      | Bool
      = false,
    "focus-mode"
      | String
      | doc "focus when moving mouse to new window"
      = "sloppy",
    "num-workspaces"
      | Integer
      | doc "static workspace count"
      = 12,
    "resize-with-right-button"
      | Bool
      = true,
    "workspace-names"
      | Array String
      = [
        "Workspace 1",
        "Workspace 2",
        "Workspace 3",
        "Workspace 4",
        "Workspace 5",
        "Workspace 6",
        "Workspace 7",
        "Workspace 8"
      ],
  },
}
in

let wm_keybindings = {
  path = "org/gnome/desktop/wm/keybindings",
  keys = {
    "maximize"
      | Array String
      = ["<Super>Up"],
    "minimize"
      | Array String
      = [],
    "move-to-monitor-down"
      | Array String
      = ["<Super><Shift>Down"],
    "move-to-monitor-left"
      | Array String
      = ["<Super><Shift>Left"],
    "move-to-monitor-right"
      | Array String
      = ["<Super><Shift>Right"],
    "move-to-monitor-up"
      | Array String
      = ["<Super><Shift>Up"],
    "move-to-workspace-down"
      | Array String
      = ["<Control><Shift><Alt>Down"],
    "move-to-workspace-left"
      | Array String
      = [
        "<Super><Shift>Page_Up",
        "<Super><Shift>KP_Prior",
        "<Super><Shift><Alt>Left",
        "<Control><Shift><Alt>Left"
      ],
    "move-to-workspace-right"
      | Array String
      = [
        "<Super><Shift>Page_Down",
        "<Super><Shift>KP_Next",
        "<Super><Shift><Alt>Right",
        "<Control><Shift><Alt>Right"
      ],
    "move-to-workspace-up"
      | Array String
      = ["<Control><Shift><Alt>Up"],
    "switch-applications"
      | Array String
      = ["<Super>Tab", "<Alt>Tab"],
    "switch-applications-backward"
      | Array String
      = ["<Shift><Super>Tab", "<Shift><Alt>Tab"],
    "switch-group"
      | Array String
      = ["<Super>Above_Tab", "<Alt>Above_Tab"],
    "switch-group-backward"
      | Array String
      = ["<Shift><Super>Above_Tab", "<Shift><Alt>Above_Tab"],
    "switch-input-source"
      | Array String
      = [],
    "switch-input-source-backward"
      | Array String
      = [],
    "switch-panels"
      | Array String
      = ["<Control><Alt>Tab"],
    "switch-panels-backward"
      | Array String
      = ["<Shift><Control><Alt>Tab"],
    "switch-to-workspace-1"
      | Array String
      = ["<Super>Home"],
    "switch-to-workspace-last"
      | Array String
      = ["<Super>End"],
    "switch-to-workspace-left"
      | Array String
      = [
        "<Super>Page_Up",
        "<Super>KP_Prior",
        "<Super><Alt>Left",
        "<Control><Alt>Left"
      ],
    "switch-to-workspace-right"
      | Array String
      = [
        "<Super>Page_Down",
        "<Super>KP_Next",
        "<Super><Alt>Right",
        "<Control><Alt>Right"
      ],
    "unmaximize"
      | Array String
      = ["<Super>Down", "<Alt>F5"],
  },
}
in

let mutter = {
  path = "org/gnome/mutter",
  keys = {
    "attach-modal-dialogs"
      | Bool
      = false,
    "dynamic-workspaces"
      | Bool
      | doc "finite workspaces"
      = false,
    "edge-tiling"
      | Bool
      | doc "not compatible with albumwm"
      = false,
    "overlay-key"
      | String
      | doc "empty string disables the overlay shortcut"
      = "",
    "workspaces-only-on-primary"
      | Bool
      = true,
  },
}
in

let mutter_keybindings = {
  path = "org/gnome/mutter/keybindings",
  keys = {
    "cancel-input-capture"
      | Array String
      = ["<Super><Shift>Escape"],
    "toggle-tiled-left"
      | Array String
      | doc "disable left tile arrow key"
      = [],
    "toggle-tiled-right"
      | Array String
      | doc "disable right tile arrow key"
      = [],
  },
}
in

let mutter_wayland_keybindings = {
  path = "org/gnome/mutter/wayland/keybindings",
  keys = {
    "restore-shortcuts"
      | Array String
      = ["<Super>Escape"],
  },
}
in

let shell_keybindings = {
  path = "org/gnome/shell/keybindings",
  keys = {
    "focus-active-notification"
      | Array String
      = ["<Super>n"],
    "shift-overview-down"
      | Array String
      = ["<Super><Alt>Down"],
    "shift-overview-up"
      | Array String
      = ["<Super><Alt>Up"],
    "toggle-message-tray"
      | Array String
      = ["<Super>v", "<Super>m"],
    "toggle-quick-settings"
      | Array String
      = [],
  },
}
in

let media_keys = {
  path = "org/gnome/settings-daemon/plugins/media-keys",
  keys = {
    "custom-keybindings"
      | Array String
      | doc "registered custom shortcut dirs"
      = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/",
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/",
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/",
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ],
    "help"
      | Array String
      = [],
    "rotate-video-lock-static"
      | Array String
      = ["<Super>o", "XF86RotationLockToggle"],
    "screensaver"
      | Array String
      = ["<Super>Pause"],
    "search"
      | Array String
      = ["<Super>space"],
  },
}
in

let open_terminal = {
  path = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0",
  keys = {
    "binding" = "<Super>Return",
    "command" = "ghostty",
    "name" = "ghostty",
  },
}
in

let mpc_toggle = {
  path = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1",
  keys = {
    "binding" = "<Shift><Super>p",
    "command" = "/home/linuxbrew/.linuxbrew/bin/mpc -h /run/user/6969/mpd/socket toggle",
    "name" = "mpc toggle",
  },
}
in

let mpc_next = {
  path = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2",
  keys = {
    "binding" = "<Shift><Super>n",
    "command" = "/home/linuxbrew/.linuxbrew/bin/mpc -h /run/user/6969/mpd/socket next",
    "name" = "mpc next",
  },
}
in

let mpc_prev = {
  path = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3",
  keys = {
    "binding" = "<Shift><Super>b",
    "command" = "/home/linuxbrew/.linuxbrew/bin/mpc -h /run/user/6969/mpd/socket prev",
    "name" = "mpc prev",
  },
}
in

let main =
  render [
    albumwm,
    albumwm_keybindings,
    wm_preferences,
    wm_keybindings,
    mutter,
    mutter_keybindings,
    mutter_wayland_keybindings,
    shell_keybindings,
    media_keys,
    open_terminal,
    mpc_toggle,
    mpc_next,
    mpc_prev,
  ]
in

main
