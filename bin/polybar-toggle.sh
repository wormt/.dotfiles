#!/bin/sh
if [ ! -w "$XDG_CONFIG_HOME"/polybar/wfs ];then
	pkill -x polybar
	touch "$XDG_CONFIG_HOME"/polybar/wfs
elif [ -w "$XDG_CONFIG_HOME"/polybar/wfs ];then
	exec polybar&
	rm "$XDG_CONFIG_HOME"/polybar/wfs
else printf 'bad crop\n'
fi
