#!/bin/sh
for pathitem in $(echo $PATH | sed -e 's/:/ /g'); do echo $pathitem; ls -1 $pathitem; echo ""; done | sort -u --parallel=4 > ~/.cache/path
