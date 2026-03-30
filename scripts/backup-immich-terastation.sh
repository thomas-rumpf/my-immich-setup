#!/bin/bash

# weekly backup to terastation

# mount terastation backup folder
mount /mnt/media/terastation

# Define source and target
SOURCE_DIR="/home/thomas/immich/media/"
TARGET_DIR="/mnt/media/terastation/"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG="/home/thomas/immich/log/immich-backup_W_log_$TIMESTAMP.txt"

# log Datei anlegen. Name ist das aktuelle Datum
touch $LOG

# Copy files recursively, preserving attributes
rsync -avh --delete "$SOURCE_DIR" "$TARGET_DIR" >> $LOG

# give rsync some time to execute, just in case it'll take a little longer
sleep 180

# create notification message
# Extract counts for each user
# check the log file for the number of images that have been backed up
THOMAS_COUNT=$(grep -c "library/admin/.*IMG.*\.jpg" "$LOG")
JOHANNA_COUNT=$(grep -c "library/johanna/.*IMG.*\.jpg" "$LOG")
UTE_COUNT=$(grep -c "library/ute/.*IMG.*\.jpg" "$LOG")
MESSAGE=$"Immich Daily Backup completed. number of images backed up Thomas:$THOMAS_COUNT Johanna:$JOHANNA_COUNT Ute:$UTE_COUNT"

# send nitification via Ntfy
curl -d "$MESSAGE" ntfy.sh/RumpfiesAlert > /dev/null

# mount entfernen
umount /mnt/media/terastation


