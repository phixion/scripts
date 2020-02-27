#!/bin/bash
#install debs from urls i.e. post fwupd deployment for unifi devices
#sudo bash -c "wget https://raw.githubusercontent.com/phixion/scripts/master/dpkg-get.sh -O- | tr -d '\r' > /usr/local/bin/dpkg-get && \
#chmod a+x /usr/local/bin/dpkg-get"

dir="/tmp/dpkg-get"
url="$1"
file="${url##*/}"
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi
[ -d $dir ] || mkdir $dir
wget -q --show-progress -O "$dir/$file" $url && \
dpkg -i "$dir/$file"
