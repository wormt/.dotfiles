\(globals : ../globals/Globals.dhall) ->
\(pallete : ../themes/Schema.dhall) ->
  { buffer =
    { nickname.color = "unique"
    , server_messages =
      { change_nick.smart = 600
      , join.smart = 600
      , part.smart = 600
      , quit.smart = 600
      }
    , typing.font_size = 12
    }
  , font = { line_height = 1.15, size = 12 }
  , notifications.direct_message = { show_toast = True, sound = "peck" }
  , scale_factor = 1.4
  , servers.gngr
    =
    { nickname = "iwr"
    , sasl.plain = { username = "iwr", password_file = "password.txt" }
    , server = "domain.com"
    }
  , theme = pallete.halloy
  }
