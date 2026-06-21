#!/bin/sh

# chimera linux

#apk update&&apk upgrade -la --no-interactive
#flatpak update -y
#flatpak --user update -y
#fwupdmgr refresh&&fwupdmgr update
#parallel --halt now,fail=1 ::: \
#  "apk update && apk upgrade -la --no-interactive" \
#  "fwupdmgr refresh --force && fwupdmgr update" \
#  "flatpak update -y" \
#  "flatpak --user update -y"
#sbctl verify

# secureblue

parallel -j 4 -- \
  "rpm-ostree update" \
  "ujust update-firmware" \
  "brew update -v " \
  "flatpak update -y" \
  "flatpak --user update -y"
