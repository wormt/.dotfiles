\(globals : ../globals/Globals.dhall) ->

{ buffer =
    { nickname.color = "unique"
    , server_messages =
        { change_nick = 600
        , join        = 600
        , part        = 600
        , quit        = 600
        }
    , typing.font_size = 12
    }
, font                          = { line_height = 1.15
                                  , size        = 12
                                  }
, notifications.direct_message  = { show_toast = True, sound = "peck" }
, scale_factor                  = 1.4
, servers.gngr =
    { nickname   = "iwr"
    , sasl.plain = { username = "iwr"
                   , password_file = "password.txt"
                   }
    , server     = "domain.com"
    }
, theme = globals.theme
}
