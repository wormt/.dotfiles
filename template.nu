#!/usr/bin/env nu

# for nickel:
cd nickel
let nickel_configs = (open --raw host.kdl | from kdl | get 0.children)

for config in $nickel_configs {
  let src = ($config.children | where name == "src" | first | get args.0)
  let output = ($config.children | where name == "output" | first | get args.0)
  let format = ($config.children | where name == "format" | first | get args.0)
  # expand key=@file overrides to file contents
  let args = ($config.children | where name == "override" | each {|override|
    let value = $override.args.0
    let expanded = if ($value | str contains "=@") {
      let parts = ($value | split row "=@")
      let file = $parts.1
      let content = if ($file | path exists) { cat $file } else { "{}" }
      $"($parts.0)=($content)"
    } else { $value }
    ["--override", $expanded]
  } | flatten)

  let dest = ($output | path expand)
  mkdir ($dest | path dirname)
  # customize-mode args (--override etc.) must follow the `--` separator
  nickel export $src --format $format -- ...$args | save -f $dest
  print $"nickel ($src) -> ($dest)"
}

# for dhall:
# host.yaml format is a list of dicts with the following schema:
# ---
# halloy:
#   format: toml
#   outputs:
#     config: "~/.config/halloy/config.toml"
#     theme: "~/.config/halloy/themes/ayu-dark.toml"
# ghostty:
#   format: key_eq_value
#   outputs:
#     config: "~/.config/ghostty/config"

cd ../dhall
let data = (cat config.dhall | dhall-to-json | from json)

# this for loop sucks.
for app in (open host.yaml | transpose key value) {

    let format = ($app.value.format? | default "toml")
    for out in ($app.value.outputs | transpose subkey dest) {

        let record = $data | get $app.key | get $out.subkey

        if $format == "raw_transient" {
          $record 
          print $"($app.key) loaded."
          break
        }

        let dest = ($out.dest | path expand)
        mkdir ($dest | path dirname)

        # format logic here:
        let content = if $format == "key_eq_value" {
            # i.e. ghostty
            ($record | transpose key value | each {|r| $"($r.key) = ($r.value)" } | str join "\n") + "\n"
        } else if $format == "toml" {
            $record | to toml
        } else {
          # format not found
          print -e $"(ansi red_bold)($app.key): invalid format"
          continue
        }

        $content | save -f $dest
        print $"($app.key) -> ($dest)"
    }
}
