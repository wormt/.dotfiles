#!/usr/bin/env nu

def clip-and-print [url: string, clip: bool] {
    print $url
    if $clip {
        $url | ^wl-copy -n
    }
}

def catbox-upload [endpoint: string, file: path, --extra: list<string> = []] {
    let args = ["-fsSL" "-F" "reqtype=fileupload"] ++ $extra ++ ["-F" $"fileToUpload=@($file)" $endpoint]
    let result = (^curl ...$args | complete)
    if $result.exit_code != 0 {
        error make {msg: $"upload failed: ($result.stderr | str trim)"}
    }
    let body = ($result.stdout | str trim)
    if not ($body | str starts-with "http") {
        error make {msg: $"upload failed: ($body)"}
    }
    $body
}

def pomf-upload [endpoint: string, file: path] {
    let result = (^curl -fsSL -F $"files[]=@($file)" $endpoint | complete)
    if $result.exit_code != 0 {
        error make {msg: $"upload failed: ($result.stderr | str trim)"}
    }
    let parsed = ($result.stdout | from json)
    if not $parsed.success {
        error make {msg: $"upload failed: ($parsed.description? | default 'unknown error')"}
    }
    $parsed.files.0.url
}

export def upload [
    file: path
    --target(-t): string = "catbox"
    --expiry(-e): string = "24h"
    --clip(-c)
] {
    if not ($file | path exists) {
        error make {msg: $"file not found: ($file)"}
    }
    let url = match $target {
        "catbox" => (catbox-upload "https://catbox.moe/user/api.php" $file)
        "litterbox" => {
            if $expiry not-in ["1h" "12h" "24h" "72h"] {
                error make {msg: $"--expiry must be one of 1h, 12h, 24h, 72h, got ($expiry)"}
            }
            catbox-upload "https://litterbox.catbox.moe/resources/internals/api.php" $file --extra ["-F" $"time=($expiry)"]
        }
        "uguu" => (pomf-upload "https://uguu.se/upload" $file)
        "pomf" => (pomf-upload "https://pomf.lain.la/upload.php" $file)
        _ => {
            error make {msg: $"unknown target ($target), expected catbox, litterbox, uguu, or pomf"}
        }
    }
    clip-and-print $url $clip
}

export def paste [
    input: string
    --target(-t): string = "tor"
    --host(-H): string = "https://gbin.me"
    --expire(-e): int = 0
    --secret(-s): string = ""
    --clip(-c)
    --insecure(-k)
] {
    if ($input | str starts-with "http://") or ($input | str starts-with "https://") {
        let result = (^curl -fsSL --output - --socks5-hostname localhost:9050 $input | complete)
        if $result.exit_code != 0 {
            error make {msg: $"fetch failed: ($result.stderr | str trim)"}
        }
        print -n $result.stdout
        return
    }
    if not ($input | path exists) {
        error make {msg: $"file not found: ($input)"}
    }
    let url = match $target {
        "tor" => {
            let onion = "http://aviauws3ledmijk64le656g47yqjlfephtfs276gshkf3wqjdt7zd7yd.onion"
            let result = (^curl -fsSL --socks5-hostname localhost:9050 --data-binary $"@($input)" $onion | complete)
            if $result.exit_code != 0 {
                error make {msg: $"paste failed: ($result.stderr | str trim)"}
            }
            $result.stdout | str trim
        }
        "ghostbin" => {
            let expire_args = if $expire > 0 { ["-F" $"expire=($expire)"] } else { [] }
            let secret_args = if not ($secret | is-empty) { ["-F" $"secret=($secret)"] } else { [] }
            let host_url = if ($host | str starts-with "http") { $host } else { $"https://($host)" }
            let insecure_args = if $insecure { ["-k"] } else { [] }
            let all_args = ["-fsSL" "-F" $"f=@($input)"] ++ $expire_args ++ $secret_args ++ $insecure_args ++ [$host_url]
            let result = (^curl ...$all_args | complete)
            if $result.exit_code != 0 {
                error make {msg: $"paste failed: ($result.stderr | str trim)"}
            }
            $result.stdout | str trim
        }
        _ => {
            error make {msg: $"unknown target ($target), expected tor or ghostbin"}
        }
    }
    clip-and-print $url $clip
}
