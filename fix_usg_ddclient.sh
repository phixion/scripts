#!/bin/bash
# Run this script as sudo

# Specify the repo and the location of the apt sources list
DEB_REPO="deb http://archive.debian.org/debian/ wheezy main # wheezy #"
APT_SRC="/etc/apt/sources.list"

# Add deb repo to sources list if it isn't there
grep -q -F "$DEB_REPO" "$APT_SRC" || echo "$DEB_REPO" >> "$APT_SRC"

# Run Apt update
apt-get update; apt-get -y install libdata-validate-ip-perl

# Download new ddclient and replace the existing version
cd /tmp
curl -L -O https://raw.githubusercontent.com/ddclient/ddclient/master/ddclient
cp /usr/sbin/ddclient /usr/sbin/ddclient.bkp
cp ddclient /usr/sbin/ddclient
chmod +x /usr/sbin/ddclient

# Tell the USG to update configuration and then display the status
# Run the following manually to update your DDNS record:
# update dns dynamic interface eth0 && sleep 20 && show dns dynamic status
