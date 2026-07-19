#!/usr/bin/env nu

# for nickel:
cd nickel
let nickel_src = "policy.ncl"
let nickel_output = "~/.config/containers/policy.json"
mkdir ($nickel_output | path expand | path dirname)

let host_ncl = if ("host.ncl" | path exists) {
  cat host.ncl
} else {
  "{}"
}

(
  nickel export $nickel_src -- "inputs.keys_dir=\"/usr/etc/pki\""
  --override $"inputs.host_insecure = ($host_ncl)"
  | save -f ($nickel_output | path expand)
)
print $"nickel policy.json -> ($nickel_output)"

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
