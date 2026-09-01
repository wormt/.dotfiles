#!/usr/bin/env nu

def ssh-agent-local-owner [] {
    if "SSH_AUTH_SOCK" not-in $env {
        return null
    }
    let result = (^lsof -t $env.SSH_AUTH_SOCK | complete)
    if $result.exit_code != 0 or ($result.stdout | str trim | is-empty) {
        return null
    }
    let owner_pid = ($result.stdout | lines | first)
    (^ps -p $owner_pid -o comm= | complete).stdout | str trim
}

export def --env ssh-agent-start [
    key: path
    --lifetime(-l): duration = 1hr
] {
    let lifetime_secs = ($lifetime / 1sec | into int)
    if $lifetime_secs <= 0 {
        error make {msg: $"--lifetime must be greater than 0 seconds, got ($lifetime)"}
    }
    let trusted = [ssh-agent gcr-ssh-agent gnome-keyring-daemon gpg-agent]
    let owner = (ssh-agent-local-owner)
    let has_session = (($owner != null) and ($owner in $trusted) and ((^ssh-add -l | complete).exit_code != 2))
    if not $has_session {
        let socket = (^mktemp -u)
        let agent_result = (^ssh-agent -c -a $socket | complete)
        if $agent_result.exit_code != 0 {
            error make {msg: $"ssh-agent failed to start: ($agent_result.stderr | str trim)"}
        }
        for line in ($agent_result.stdout | lines) {
            if ($line | str starts-with "setenv") {
                let parts = ($line | str trim --right --char ';' | split row " ")
                if $parts.1 == "SSH_AUTH_SOCK" {
                    $env.SSH_AUTH_SOCK = $parts.2
                } else if $parts.1 == "SSH_AGENT_PID" {
                    $env.SSH_AGENT_PID = $parts.2
                }
            }
        }
        if "SSH_AGENT_PID" not-in $env {
            error make {msg: "ssh-agent did not report an agent pid"}
        }
        $env.SSH_AGENT_SPAWNED = "1"
    }
    let add_result = (^ssh-add -t $lifetime_secs $key | complete)
    if $add_result.exit_code != 0 {
        if "SSH_AGENT_SPAWNED" in $env {
            ^ssh-agent -k | ignore
            hide-env SSH_AUTH_SOCK
            hide-env SSH_AGENT_PID
            hide-env SSH_AGENT_SPAWNED
        }
        error make {msg: $"ssh-add failed: ($add_result.stderr | str trim)"}
    }
    print ($add_result.stderr | str trim)
}

export def --env ssh-agent-stop [] {
    if "SSH_AGENT_SPAWNED" in $env {
        ^ssh-agent -k | ignore
        hide-env SSH_AUTH_SOCK
        hide-env SSH_AGENT_PID
        hide-env SSH_AGENT_SPAWNED
    }
}
