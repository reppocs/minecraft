#!/usr/bin/env bash

# This is a minecraft backup script. There are many like it, but this one is mine.
# Written by: reppocs@gmail.com
#
# Usage:
# ./mcbackup.sh servername

SERVER="$1"
MCHOME=~minecraft
SERVERPATH="$MCHOME/$SERVER"
BACKUPDIR="/data/backup/minecraft/$SERVER"
CLOUDDIR="dbox:/Backup/Minecraft/$SERVER"

# If no server is specified, exit and tell them to use one.
[[ -z "$SERVER" ]] && echo "Please specify a server to back up." && exit 1

[[ ! -d "$SERVERPATH" ]] && echo "Server directory doesn't exist. Exiting." && exit 1

# If the backup directory doesn't exist, create it and set the permissions.
[[ ! -d "$BACKUPDIR" ]] && echo "Creating backup directory." && mkdir -p "$BACKUPDIR" && chmod 755 "$BACKUPDIR"

echo "Stopping minecraft - $SERVER"
systemctl stop minecraft@"$SERVER"

echo "Backing up the server directory - $SERVER"
tar -cjf "$BACKUPDIR"/"$SERVER"-backup."$(date +%Y%m%d)".tar.bz2 -C "$MCHOME" "$SERVER"

echo "Backing up $SERVER to THE CLOUD!"
# If rclone exists, do the cloud backup. If not, exit.
if [ -n "$(command -v rclone)" ]
then
    rclone copy "$BACKUPDIR"/"$SERVER"-backup."$(date +%Y%m%d)".tar.bz2 "$CLOUDDIR"
else
    echo "rclone is not available. Exiting." && exit 1
fi

echo "Removing local $SERVER backups older than a month"
find "$BACKUPDIR" -mtime +30 -print -exec rm {} \;

echo "Removing CLOUD $SERVER backups older than a month"
rclone delete --min-age 30d "$CLOUDDIR"

echo "Starting minecraft - $SERVER"
systemctl start minecraft@"$SERVER"
