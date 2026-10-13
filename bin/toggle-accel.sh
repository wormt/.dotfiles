#!/bin/sh
accel=/org/gnome/desktop/peripherals/mouse/accel-profile
speed=/org/gnome/desktop/peripherals/mouse/speed
if [ "$(dconf read $accel)" = "'flat'" ]; then
    dconf write $accel "'default'"
    dconf write $speed "0.0"
    echo "mouse: default accel, speed 0"
else
    dconf write $accel "'flat'"
    dconf write $speed "-0.1"
    echo "mouse: flat accel, speed -0.1"
fi
