#!/bin/bash

TMP_DIR="/tmp/"
DATE=$(date +"%d-%m-%Y")
BKP_FILE="$TMP_DIR/beatheads_$DATE.tar"
BKP_DIRS="/home/bot /home/blog /home/teamspeak /var/www /etc /root"
DROPBOX_UPLOADER=/root/dropbox/dropbox_uploader.sh

tar cf "$BKP_FILE" $BKP_DIRS
gzip "$BKP_FILE"

$DROPBOX_UPLOADER -f /root/.dropbox_uploader upload "$BKP_FILE.gz" /

rm -fr "$BKP_FILE.gz"
DELDATE=`date --date="-10 day" +%d-%m-%Y`
sh /root/dropbox/dropbox_uploader.sh delete beatheads_${DELDATE}.tar.gz
