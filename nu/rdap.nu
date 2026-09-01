#!/usr/bin/env nu

export def rdap [
    query: string
    --host(-H): string = "https://who.zmh.me"
    --raw(-r)
] {
    let host_url = if ($host | str starts-with "http") { $host } else { $"https://($host)" }
    let encoded = ($query | url encode)
    let parsed = (try {
        http get --allow-errors $"($host_url)/api/lookup?query=($encoded)"
    } catch {|err|
        error make {msg: $"lookup failed: ($err.debug)"}
    })
    if not $parsed.status {
        error make {msg: $"lookup failed: ($parsed.error? | default 'unknown error')"}
    }
    if $raw {
        $parsed
    } else {
        $parsed.result
    }
}
