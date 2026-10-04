# Ghostty config, templated in Nickel. Colors from shared palette.ncl.
# Rendered as `key = value` text (nickel export --format text).

let colors = import "palette.ncl" in

let Hex =
  std.contract.from_predicate (fun s =>
    std.is_string s && std.string.is_match "^#[0-9A-Fa-f]{6}$" s
  )
in

let Value = std.contract.any_of [ Bool, Number, String ] in

let renderValue
  | Value -> String
  = fun v =>
    if std.is_bool v then
      (if v then "true" else "false")
    else if std.is_number v then
      std.string.from_number v
    else
      v
in

# `key = value` per line; a `palette` array becomes one `palette = N=#hex` line per entry.
let render
  | { _ : Dyn } -> String
  = fun settings =>
    std.record.to_array settings
    |> std.array.flat_map (fun kv =>
      if std.is_array kv.value then
        std.array.generate
          (fun i => "%{kv.field} = %{std.string.from_number i}=%{std.array.at i kv.value}")
          (std.array.length kv.value)
      else
        [ "%{kv.field} = %{renderValue kv.value}" ]
    )
    |> std.string.join "\n"
    |> (fun s => s ++ "\n")
in

let main = {
  inputs | not_exported = {
    shell | String | doc "program ghostty launches" | default = "nu",
  },

  settings = {
    "background" | Hex | doc "default background" = colors.background,
    "foreground" | Hex | doc "default foreground" = colors.foreground,
    "selection-background" | Hex | doc "selection background" = colors.selection,
    "selection-foreground" | Hex | doc "selection foreground" = colors.foreground,
    "cursor-color" | Hex | doc "cursor color" = colors.foreground,
    "cursor-text" | Hex | doc "text color under the cursor" = colors.background,
    "palette"
      | Array Hex
      | doc "ANSI colors 0-15: normal then bright"
      = [
        colors.normal.black,
        colors.normal.red,
        colors.normal.green,
        colors.normal.yellow,
        colors.normal.blue,
        colors.normal.magenta,
        colors.normal.cyan,
        colors.normal.white,
        colors.bright.black,
        colors.bright.red,
        colors.bright.green,
        colors.bright.yellow,
        colors.bright.blue,
        colors.bright.magenta,
        colors.bright.cyan,
        colors.bright.white,
      ],
    "font-family" | String | doc "font family" | default = "monospace",
    "font-size" | Number | doc "font size in points" | default = 10,
    "window-decoration" | Bool | doc "draw window decorations" | default = true,
    "window-save-state" | String | doc "restore window state on launch" | default = "always",
    "cursor-style" | String | doc "cursor shape" | default = "block",
    "cursor-style-blink" | Bool | doc "blink the cursor" | default = true,
    "command" | String | doc "program to run" = inputs.shell,
    "gtk-titlebar-style" | String | doc "GTK titlebar style" | default = "tabs",
    "confirm-close-surface" | String | doc "confirm before closing a surface" | default = "false",
  },
}
in

render main.settings
