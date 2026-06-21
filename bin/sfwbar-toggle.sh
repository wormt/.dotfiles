#!/bin/sh
if [ ! -w "$XDG_CONFIG_HOME"/sfwbar/wfs ];then
	pkill -9 -x sfwbar
	touch "$XDG_CONFIG_HOME"/sfwbar/wfs
elif [ -w "$XDG_CONFIG_HOME"/sfwbar/wfs ];then
	nohup sfwbar -f "$XDG_CONFIG_HOME"/sfwbar/sfwbar.config > /dev/null&
	rm "$XDG_CONFIG_HOME"/sfwbar/wfs
else printf 'bad crop\n'
fi
