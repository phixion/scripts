#!/bin/bash
cd /etc/pacman.d/
cp mirrorlist mirrorlist.bak
rankmirrors -n 6 mirrorlist.bak > mirrorlist
pacman -Syy
