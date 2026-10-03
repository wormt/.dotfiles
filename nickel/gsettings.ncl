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

let common = {
  horizontal_margin = 8,
  vertical_margin = 6,
  window_gap = 8,

  close_window = ["<Shift><Super>q"],
  cycle_height_backwards = ["<Super><Alt><Shift>r"],
  cycle_width_backwards = ["<Super><Alt>r"],
  dec_window_height = ["<Shift><Super>underscore"],
  dec_window_width = ["<Shift><Super>braceleft"],
  focus_monitor_above = ["<Alt><Super>k"],
  focus_monitor_below = ["<Alt><Super>j"],
  focus_monitor_left = ["<Alt><Super>h"],
  focus_monitor_right = ["<Alt><Super>l"],
  focus_window_down = ["<Super>j"],
  focus_window_left = ["<Super>h"],
  focus_window_right = ["<Super>l"],
  focus_window_up = ["<Super>k"],
  inc_window_width = ["<Shift><Super>braceright"],
  move_to_monitor_above = ["<Shift><Control><Super>k"],
  move_to_monitor_below = ["<Shift><Control><Super>j"],
  move_to_monitor_left = ["<Shift><Control><Super>h"],
  move_to_monitor_right = ["<Shift><Control><Super>l"],
  move_window_down = ["<Shift><Super>j"],
  move_window_left = ["<Shift><Super>h"],
  move_window_right = ["<Shift><Super>l"],
  move_window_up = ["<Shift><Super>k"],
}
in

let albumwm = {
  path = "org/gnome/shell/extensions/albumwm",
  keys = {
    "column-gap"
      | Integer
      | doc "horizontal space between tiled columns"
      = common.window_gap,
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
      = common.horizontal_margin,
    "vertical-margin"
      | Integer
      | doc "top/bottom margin inside the work area"
      = common.vertical_margin,
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
      = common.close_window,
    "cycle-focus-modes"
      | Array String
      | doc "cycle default/center/edge focus mode"
      = [""],
    "cycle-preset-column-width-backwards"
      | Array String
      = common.cycle_width_backwards,
    "cycle-preset-window-height-backwards"
      | Array String
      = common.cycle_height_backwards,
    "dec-column-width"
      | Array String
      | doc "decrease the focused column's width"
      = common.dec_window_width,
    "dec-window-height"
      | Array String
      | doc "decrease the focused window's height"
      = common.dec_window_height,
    "focus-column-left"
      | Array String
      | doc "focus the column to the left"
      = common.focus_window_left,
    "focus-column-right"
      | Array String
      | doc "focus the column to the right"
      = common.focus_window_right,
    "focus-monitor-above"
      | Array String
      = common.focus_monitor_above,
    "focus-monitor-below"
      | Array String
      = common.focus_monitor_below,
    "focus-monitor-left"
      | Array String
      = common.focus_monitor_left,
    "focus-monitor-right"
      | Array String
      = common.focus_monitor_right,
    "focus-window-down"
      | Array String
      | doc "focus the window below"
      = common.focus_window_down,
    "focus-window-up"
      | Array String
      | doc "focus the window above"
      = common.focus_window_up,
    "inc-column-width"
      | Array String
      | doc "increase the focused column's width"
      = common.inc_window_width,
    "move-column-left"
      | Array String
      | doc "move the focused column left"
      = common.move_window_left,
    "move-column-right"
      | Array String
      | doc "move the focused column right"
      = common.move_window_right,
    "move-window-down"
      | Array String
      | doc "move the focused window down"
      = common.move_window_down,
    "move-window-to-monitor-above"
      | Array String
      = common.move_to_monitor_above,
    "move-window-to-monitor-below"
      | Array String
      = common.move_to_monitor_below,
    "move-window-to-monitor-left"
      | Array String
      = common.move_to_monitor_left,
    "move-window-to-monitor-right"
      | Array String
      = common.move_to_monitor_right,
    "move-window-up"
      | Array String
      | doc "move the focused window up"
      = common.move_window_up,
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

let paperwm = {
  path = "org/gnome/shell/extensions/paperwm",
  keys = {
    "disable-topbar-styling"
      | Bool
      | doc "don't restyle the GNOME top bar"
      = true,
    "gesture-enabled"
      | Bool
      | doc "touchpad swipe gestures for panning"
      = true,
    "horizontal-margin"
      | Integer
      | doc "left/right margin inside the work area"
      = common.horizontal_margin,
    "only-scratch-in-overview"
      | Bool
      | doc "only show scratch windows in the overview"
      = true,
    "selection-border-radius-top"
      | Integer
      | doc "selection border top corner radius"
      = 16,
    "selection-border-size"
      | Integer
      | doc "selection border width"
      = 4,
    "show-window-position-bar"
      | Bool
      | doc "window position bar in the top bar"
      = false,
    "vertical-margin"
      | Integer
      | doc "top margin inside the work area"
      = common.vertical_margin,
    "vertical-margin-bottom"
      | Integer
      | doc "bottom margin inside the work area"
      = common.vertical_margin,
    "window-gap"
      | Integer
      | doc "gap between tiled windows"
      = common.window_gap,
    "winprops"
      | Array String
      | doc "window property overrides"
      = [],
  },
}
in

let paperwm_keybindings = {
  path = "org/gnome/shell/extensions/paperwm/keybindings",
  keys = {
    "close-window"
      | Array String
      | doc "close the focused window"
      = common.close_window,
    "cycle-height-backwards"
      | Array String
      = common.cycle_height_backwards,
    "cycle-width-backwards"
      | Array String
      = common.cycle_width_backwards,
    "move-down"
      | Array String
      | doc "move the focused window down"
      = common.move_window_down,
    "move-down-workspace"
      | Array String
      = ["<Shift><Super>Page_Down"],
    "move-left"
      | Array String
      | doc "move the focused window left"
      = common.move_window_left,
    "move-monitor-above"
      | Array String
      = common.move_to_monitor_above,
    "move-monitor-below"
      | Array String
      = common.move_to_monitor_below,
    "move-monitor-left"
      | Array String
      = common.move_to_monitor_left,
    "move-monitor-right"
      | Array String
      = common.move_to_monitor_right,
    "move-right"
      | Array String
      | doc "move the focused window right"
      = common.move_window_right,
    "move-space-monitor-above"
      | Array String
      = [""],
    "move-space-monitor-below"
      | Array String
      = [""],
    "move-space-monitor-left"
      | Array String
      = [""],
    "move-space-monitor-right"
      | Array String
      = [""],
    "move-up"
      | Array String
      | doc "move the focused window up"
      = common.move_window_up,
    "move-up-workspace"
      | Array String
      = ["<Shift><Super>Page_Up"],
    "new-window"
      | Array String
      | doc "open a new window"
      = ["<Shift><Super>Return"],
    "resize-h-dec"
      | Array String
      | doc "decrease the focused window's height"
      = common.dec_window_height,
    "resize-w-dec"
      | Array String
      | doc "decrease the focused window's width"
      = common.dec_window_width,
    "resize-w-inc"
      | Array String
      | doc "increase the focused window's width"
      = common.inc_window_width,
    "swap-monitor-above"
      | Array String
      = ["<Shift><Alt><Super>k"],
    "swap-monitor-below"
      | Array String
      = ["<Shift><Alt><Super>j"],
    "swap-monitor-left"
      | Array String
      = ["<Shift><Alt><Super>h"],
    "swap-monitor-right"
      | Array String
      = ["<Shift><Alt><Super>l"],
    "switch-down"
      | Array String
      = [""],
    "switch-down-loop"
      | Array String
      | doc "focus the window below"
      = common.focus_window_down,
    "switch-left"
      | Array String
      = [""],
    "switch-left-loop"
      | Array String
      | doc "focus the window to the left"
      = common.focus_window_left,
    "switch-monitor-above"
      | Array String
      = common.focus_monitor_above,
    "switch-monitor-below"
      | Array String
      = common.focus_monitor_below,
    "switch-monitor-left"
      | Array String
      = common.focus_monitor_left,
    "switch-monitor-right"
      | Array String
      = common.focus_monitor_right,
    "switch-next"
      | Array String
      = [""],
    "switch-previous"
      | Array String
      = [""],
    "switch-right"
      | Array String
      = [""],
    "switch-right-loop"
      | Array String
      | doc "focus the window to the right"
      = common.focus_window_right,
    "switch-up"
      | Array String
      = [""],
    "switch-up-loop"
      | Array String
      | doc "focus the window above"
      = common.focus_window_up,
    "toggle-scratch"
      | Array String
      | doc "attach/detach the focused window to the scratch layer"
      = ["<Shift><Super>s"],
    "toggle-scratch-layer"
      | Array String
      | doc "toggle the floating scratch layer"
      = ["<Super>s"],
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
      = "click",
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
    paperwm,
    paperwm_keybindings,
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
