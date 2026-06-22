let globals = ./globals/navi.dhall
let pallete = merge {
  Ayu = ./themes/ayu-dark.pallete.dhall
} globals.theme

let theme_ghostty = merge {
  Ayu = "Ayu"
} globals.theme

in
{
  halloy  = {
    config = ./modules/halloy.dhall globals,
    theme = ./themes/halloy.theme.dhall pallete
  },
  ghostty  = {
    config = ./modules/ghostty.dhall theme_ghostty,
  }
}
