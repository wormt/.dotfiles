#!/bin/sh
uppomf="http://aviauws3ledmijk64le656g47yqjlfephtfs276gshkf3wqjdt7zd7yd.onion"
proxy="localhost:9050"
clip="wl-copy -n"

# if http pipe/redirect it to whatever like 'dumpload http://site.onion/sadfa|imv'
# im not writing that shit in here do it yourself
case "$@" in
	"http"*) curl -fsSL --output - --socks5-hostname "$proxy" "$@" ;;
	*) curl -fsSL --output - --socks5-hostname "$proxy" --data-binary @"$@" "$uppomf" | $clip ;;
esac
