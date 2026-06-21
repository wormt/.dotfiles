while [ "$(pgrep -f /usr/bin/pipewire-pulse)" = "" ]; do
	sleep 0.1
done
mpd --no-daemon&
sleep 1
yambar -sd none -c $XDG_CONFIG_HOME/yambar/labwc.yml&&/usr/libexec/xdg-desktop-portal-wlr&
