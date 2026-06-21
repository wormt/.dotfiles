#!/bin/sh
age -d -o /tmp/aged.tar.zstd "$1"
mkdir "$1".d
tar xf /tmp/aged.tar.zstd -C "$1".d
shred -u /tmp/aged.tar.zstd
read a
find "$1".d -type f -exec shred -u {} \;
rm -rf "$1".d
