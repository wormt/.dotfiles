#!/bin/sh
#mpd --kill
pkill -u "$USER" -xf '/usr/bin/python3 /usr/bin/qutebrowser'
pkill -u "$USER" -f 'swayidle'
pkill -u "$USER" -xf "wob -c $HOME/.config/wob/wlu.ini"
pkill -u "$USER" -x 'wob'
pkill -u "$USER" -xf "tail -f $HOME/.cache/wlu"
pkill -u "$USER" -xf "tail -f $HOME/.cache/wgv"
#pkill -u "$USER" 'swaybg'
#pkill -u "$USER" -x 'mako'
#pkill -u "$USER" -xf 'fusermount3 -o rw,nosuid,nodev,fsname=portal,auto_unmount,subtype=portal -- /tmp/1000/doc'
#pkill -u "$USER" -xf '/usr/libexec/xdg-document-portal'
pkill -u "$USER" -xf '/usr/libexec/xdg-desktop-portal-gtk'
pkill -u "$USER" -xf '/usr/libexec/xdg-desktop-portal-wlr'
pkill -u "$USER" -xf '/usr/libexec/xdg-desktop-portal'
#pkill -u "$USER" -xf "yambar -c $HOME/.config/yambar/labwc.yml"
#pkill -u "$USER" -xf '/usr/bin/pipewire-pulse'
#pkill -u "$USER" -xf '/usr/bin/wireplumber'
#pkill -u "$USER" -xf '/usr/bin/pipewire'
#exec pkill -u "$USER" -x 'foot'&exec labwc -e&exec pkill -u "$USER"&exec pkill -xf '/usr/libexec/xdg-document-portal'&
#labwc -e
xfce4-session-logout -lf
