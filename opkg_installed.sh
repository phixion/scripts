#!/bin/sh
#collect installed openwrt packages
#reinstall after update with opkg update && opkg install `cat /etc/config/packlist.txt` && reboot

FLASH_TIME=$(opkg info busybox | grep '^Installed-Time: ')

for i in $(opkg list-installed | cut -d' ' -f1)
do
    if [ "$(opkg info $i | grep '^Installed-Time: ')" != "$FLASH_TIME" ]
    then
        echo $i
    fi
done
