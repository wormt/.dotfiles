#!/bin/sh
DB="$(cat $XDG_DATA_HOME/pw/l|fzy -l 23)"
keepassxc-cli clip -k "$XDG_DATA_HOME"/pw/k "$XDG_DATA_HOME"/pw/p.kdbx "$DB"
