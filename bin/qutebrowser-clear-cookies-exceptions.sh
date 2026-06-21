#!/bin/sh
find "$XDG_DATA_HOME"/qutebrowser/webengine/IndexedDB -type d \
	-not -path $HOME/.local/share/qutebrowser/webengine/IndexedDB \
	-not -path $HOME/.local/share/qutebrowser/webengine/IndexedDB/https_example.com.indexeddb.leveldb \
	-exec rm -rf {} \;
rm -rf "$XDG_DATA_HOME"/qutebrowser/webengine/WebStorage "$XDG_DATA_HOME"/qutebrowser/webengine/Session\ Storage "$XDG_DATA_HOME"/qutebrowser/webengine/Local\ Storage
sqlite3 "$XDG_DATA_HOME"/qutebrowser/webengine/Cookies < $HOME/.local/xbin/qutebrowser-clear-cookies-exceptions.sql
