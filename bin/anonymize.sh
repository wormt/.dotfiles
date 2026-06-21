#!/bin/sh
EXT="$(echo $@|awk -F. '{$1="";print substr($0,2)}')"
cp -fv "$1" ~/dl/anonymize/"$(openssl rand -hex 4)"."$EXT"
