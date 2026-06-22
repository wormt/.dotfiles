$env.config.show_banner = "none"
$env.config.rm.always_trash = true
$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_insert = "block"
$env.config.cursor_shape.vi_normal = "block"
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.sort = "smart"
$env.config.footer_mode = "always"
$env.PROMPT_COMMAND_RIGHT = ""
$env.config.table.mode = "compact"
$env.config.table.show_empty = false

# Can be overridden by passing a table to `| table --index/-i`
$env.config.table.index_mode = "never"

$env.config.table.padding.left = 0
$env.config.table.padding.right = 0
$env.config.table.header_on_separator = true

#use std/config light-theme
#$env.config = {color_config: (light-theme)}

$env.config.buffer_editor = "vim"

$env.LANG = "en_US.UTF-8"
$env.XKB_DEFAULT_MODEL = "pc104"
$env.XKB_DEFAULT_LAYOUT = "us"
$env.RLIMIT_RTPRIO = "88"

$env.PATH = $env.PATH | prepend [($env.HOME + "/.local/bin"),"/home/linuxbrew/.linuxbrew/bin",($env.HOME + "/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/"),($env.HOME + "/.cargo/bin"),($env.HOME + "/.dotnet/tools"),($env.HOME + "/.local/share/fnm/node-versions/lts/installation/bin")] | uniq
if 'DEVSHELL_DIR' in $env {
  $env.PATH = ($env.PATH | prepend $"($env.DEVSHELL_DIR)/bin")
}
$env.XDG_DATA_HOME = $env.HOME + "/.local/share"
$env.XDG_CONFIG_HOME = $env.HOME + "/.config"
$env.XDG_STATE_HOME = $env.HOME + "/.local/state"
$env.XDG_CACHE_HOME = $env.HOME + "/.cache"
$env.XDG_DATA_DIRS = "/usr/local/share:/usr/share:" + $env.XDG_DATA_HOME + ":/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpaks/exports/share:" + $env.HOME + "/.local/share/flatpak/exports/share:/home/linuxbrew/.linuxbrew/share"
$env.EDITOR = "vim"

$env.XCURSOR_SIZE = 24

$env.HISTSIZE = 1048576

$env.VIRTUAL_ENV_DISABLE_PROMPT = true

# https://github.com/jlcrochet/fast-completer
# $env.config.completions.external = {
#     enable: true
#     completer: {|spans|
#         match $spans.0 {
#             az | aws | gcloud | gh => {
#                 let completions = ^fast-completer --add-space --full-commands tsv ...$spans
#                 if ($completions | is-not-empty) {
#                     $completions | lines | split column -n 2 "\t" value description
#                 }
#             }
#             # Optional: fall back to carapace
#             _ => {
#                 let completions = ^carapace $spans.0 nushell ...$spans
#                 if ($completions | is-not-empty) {
#                     $completions | from json
#                 }
#             }
#         }
#     }
# }

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $fish_completer
        }
    }
}

# let azpath = '/home/linuxbrew/.linuxbrew/share/fish/vendor_completions.d/az.fish'
# if ($azpath | open | find proxychains) == [] {
#   print ("WARNING" +
#   "\n\naz completions will NOT be proxied via tor..." +
#   "\nEdit " + $azpath)
# }

# alias vim = vimx

# Azure CLI wrapper
@complete external
def --wrapped --env az [...args] {
  $env.AZURE_CORE_OUTPUT = "jsonc"
  $env.AZURE_CORE_DISABLE_CONFIRM_PROMPT = true
  $env.AZURE_EXTENSION_USE_DYNAMIC_INSTALL = false

  if ($args.0 == 'login') {
    ^az ...$args
    # ^proxychains4 -q az ...$args
  } else {
    $env.o = (^az ...$args)
    # $env.o = (^proxychains4 -q az ...$args)

    try {
      $env.o | from json
    } catch {
      $env.o
    }
  }
}

def curlbash [...args] {
  let download = (^curl --proto '=https' --tlsv1.2 -sSfL ...$args)
  $download | less
  print ("Run script? (Y/n)")
  let user_input = (
    input -d 'y' | match $in {
      'Y' | 'y' | 'Yes' | 'yes' => true
      'N' | 'n' | 'No' | 'no' => false
    }
  )

  if ($user_input) {
    try {
      $download | bash
    }
  }
}

let osrelease = (open /etc/os-release | parse --regex '(?P<key>[^=]*)=(?P<value>.*$)' | transpose -r )

overlay use "~/.py_env/bin/activate.nu"
#overlay use "~/.config/nushell/nupm/nupm" --prefix
