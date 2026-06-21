#!/bin/sh
"$HOME/.local/xbin/qutebrowser-clear-cookies-exceptions.sh" && echo 'cleared cookies'
exec /usr/bin/qutebrowser "$@"
