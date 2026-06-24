let globals = ./globals/navi.dhall

let pallete = ./themes/ayu-dark.pallete.dhall

in  { halloy =
      { config = ./modules/halloy.dhall globals pallete
      , theme = ./themes/halloy.theme.dhall pallete
      }
    , ghostty.config = ./modules/ghostty.dhall pallete
    , dconf.config = ./modules/dconf.dhall globals
    }
