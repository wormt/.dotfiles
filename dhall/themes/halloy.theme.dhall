\(p : ./Schema.dhall) ->
  { general =
    { background = p.bg0
    , border = p.bg4
    , horizontal_rule = p.bg4
    , horizontal_rule_text = p.fg1
    , scrollbar = p.bg4
    , unread_indicator = p.orange_dim
    , highlight_indicator = p.orange
    }
  , text =
    { primary = p.fg0
    , secondary = p.fg1
    , tertiary = p.cyan
    , success = p.green
    , error = p.red
    , warning = p.orange_dim
    , info = p.blue
    , debug = p.amber
    , trace = p.fg1
    }
  , buffer =
    { action = p.amber
    , background = p.bg0
    , background_text_input = p.bg1
    , background_title_bar = p.bg1
    , border = p.bg4
    , border_selected = p.fg1
    , code = p.cyan
    , highlight = p.bg3
    , nickname = p.orange_dim
    , nickname_offline = p.fg1
    , selection = p.bg3
    , timestamp = p.fg1
    , topic = p.fg1
    , url = p.blue
    , server_messages.default = p.fg1
    }
  , buttons =
    { primary =
      { background = p.bg0
      , background_hover = p.bg2
      , background_selected = p.bg3
      , background_selected_hover = p.bg4
      }
    , secondary =
      { background = p.bg1
      , background_hover = p.bg3
      , background_selected = p.bg4
      , background_selected_hover = p.bg5
      }
    }
  , formatting =
    { white = p.white
    , black = p.bg0
    , blue = p.blue
    , lightblue = p.blue_light
    , cyan = p.cyan
    , green = p.green
    , lightgreen = p.green_light
    , red = p.red_soft
    , orange = p.orange
    , yellow = p.yellow
    , brown = p.amber
    , grey = p.fg1
    , lightgrey = p.fg0
    }
  }
