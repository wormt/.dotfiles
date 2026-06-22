#!/usr/bin/env nu

let data = (cat dhall/config.dhall | dhall-to-json | from json)

for app in (open dhall/host.yaml | transpose key value) {
    for out in ($app.value | transpose subkey dest) {
        let record = $data | get $app.key | get $out.subkey
        let dest = ($out.dest | path expand)
        mkdir ($dest | path dirname)
        $record | to toml | save -f $dest
        print $"($app.key): ($dest)"
    }
}
