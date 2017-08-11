#!/bin/bash
# updates my squid ACL with latest ad/spam adresses

# get new ad server list
curl -sS -L --compressed "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext" > /etc/squid3/ad_block.txt
# refresh squid
/usr/sbin/squid3 -k reconfigure
