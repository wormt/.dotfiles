# herdr config, templated in Nickel. Rendered to ~/.config/herdr/config.toml.

let Ayu = import "palette.ncl" in

let RowCellRecord = {
  token | String,
  bold | Bool | optional,
  dim | Bool | optional,
  fg | String | optional,
} in

let RowCell = std.contract.any_of [String, RowCellRecord] in

let main = {
  inputs | not_exported = {
    palette
      | { accent | String, bg | String, selection | String, branch | String, git_status | String, .. }
      | doc "Ayu palette shared with Ghostty"
      | default = Ayu,

    toast_delivery
      | String
      | doc "toast delivery: system (D-Bus), terminal, or osc9"
      | default = "system",

    sound_enabled
      | Bool
      | doc "master sound toggle"
      | default = true,

    sound_agents
      | { _ : String }
      | doc "per-agent sound map, e.g. { pi = \"on\" }"
      | default = { pi = "on" },
  },

  onboarding
    | Bool
    | doc "skip first-run onboarding"
    | default = false,

  ui = {
    status_indicators
      | String
      | doc "status indicator style: symbols or text"
      | default = "symbols",

    show_agent_labels_on_pane_borders
      | Bool
      | doc "show agent labels on pane borders"
      | default = true,

    agent_panel_sort
      | String
      | doc "agent panel sort order"
      | default = "spaces",

    accent
      | String
      | doc "Ayu signature orange"
      | default = inputs.palette.accent,

    tab_bar_position
      | String
      | doc "tab bar position: bottom (vim-statusline vibe) or top"
      | default = "bottom",

    tab_bar_right
      | Array { type | String, format | String | optional }
      | doc "right-side tab bar widgets"
      | default = [
        { type = "zoom" },
        { type = "hostname" },
        { type = "datetime", format = "%H:%M" },
      ],

    window_title
      | String
      | doc "window title template"
      | default = "{hostname}: {workspace} · {tab}",

    sidebar_width
      | Number
      | doc "sidebar width"
      | default = 30,

    sidebar_min_width
      | Number
      | doc "sidebar minimum width"
      | default = 20,

    sidebar_max_width
      | Number
      | doc "sidebar maximum width"
      | default = 38,

    sidebar = {
      agents = {
        rows
          | Array (Array RowCell)
          | doc "agent sidebar row templates"
          | default = [
            ["state_icon", { token = "workspace", bold = true }, { token = "tab", dim = true }],
            ["state_text", { token = "agent", bold = true }],
            [{ token = "terminal_title_stripped", dim = true }],
          ],
      },

      spaces = {
        rows
          | Array (Array RowCell)
          | doc "spaces sidebar row templates"
          | default = [
            ["state_icon", { token = "workspace", bold = true }],
            [
              { token = "branch", fg = inputs.palette.branch },
              { token = "git_status", fg = inputs.palette.git_status },
            ],
          ],
      },
    },

    toast = {
      delivery
        | String
        | doc "toast delivery: system (D-Bus), terminal, or osc9"
        | default = inputs.toast_delivery,

      delay_seconds
        | Number
        | doc "toast delay in seconds (0 = instant)"
        | default = 0,

      herdr = {
        position
          | String
          | doc "herdr toast position"
          | default = "top-right",
      },

      clipboard = {
        enabled
          | Bool
          | doc "clipboard toast enabled"
          | default = true,

        position
          | String
          | doc "clipboard toast position"
          | default = "top-right",
      },
    },

    sound = {
      enabled
        | Bool
        | doc "master sound toggle"
        | default = inputs.sound_enabled,

      agents
        | { _ : String }
        | doc "per-agent sound map"
        | default = inputs.sound_agents,
    },
  },

  theme = {
    name
      | String
      | doc "theme name"
      | default = "terminal",

    auto_switch
      | Bool
      | doc "auto-switch theme"
      | default = false,

    custom = {
      accent
        | String
        | doc "Ayu signature orange"
        | default = inputs.palette.accent,

      active_row_bg
        | String
        | doc "Ayu Mirage bg — focused-row pop"
        | default = inputs.palette.bg,

      selection_bg
        | String
        | doc "selection background"
        | default = inputs.palette.selection,
    },
  },

  experimental = {
    kitty_graphics
      | Bool
      | doc "pane image rendering; disable if any glitch"
      | default = true,
  },

  advanced = {
    scrollback_limit_bytes
      | Number
      | doc "scrollback buffer limit in bytes"
      | default = 25000000,
  },
}

in main