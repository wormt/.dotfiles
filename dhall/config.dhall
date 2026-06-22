let globals = ./dhall/globals/navi.dhall
let pallete = ./dhall/themes/ayu-dark.pallete.dhall

in
{
  halloy  = {
    config = ./dhall/modules/halloy.dhall globals,
    theme = ./dhall/themes/halloy.theme.dhall pallete
  }
}
