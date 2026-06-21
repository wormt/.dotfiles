#!/bin/sh
for URL; do true; done #get last arg
URL=`echo "$URL"|awk -F/ '{print $1$2"\/\/"$3}'`
AddSite () {
	printf "%s\n" "$1" >> "$2"
	sort -u "$2" -o "$2"
}
while getopts "cgis" opt; do
	case "$opt" in
		c) AddSite "config.set('content.cookies.accept', 'no-3rdparty', '$URL')" \
				"$HOME/.config/qutebrowser/sites-cookies.py" &&
				qutebrowser ":message-info cookies.accept\ $URL\ True"
			;;
		g) AddSite "config.set('content.webgl', True, '$URL')" \
				"$HOME/.config/qutebrowser/sites-webgl.py" &&
				qutebrowser ":message-info webgl\ $URL\ True"
			;;
		i) AddSite "config.set('content.images', True, '$URL')" \
				"$HOME/.config/qutebrowser/sites-images.py" &&
				qutebrowser ":message-info images\ $URL\ True"
			;;
		s) AddSite "config.set('content.javascript.enabled', True, '$URL')" \
				"$HOME/.config/qutebrowser/sites-javascript.py" &&
				qutebrowser ":message-info javascript.enabled\ $URL\ True"
			;;
		h|*)
			help;exit
			;;
	esac
done
