#!/usr/bin/env sh

lockfile=~/.rightflick/owner/repo/lock.yml
lockpath="$(dirname $lockfile)"

mkdir -p "$lockpath"
# Set the directory's permissions to restrict write access
chown root "$lockpath"
chmod 755 "$lockpath"

touch "$lockfile"
# Make the file writeable only by root
chown root "$lockfile"
chmod 644 "$lockfile"
