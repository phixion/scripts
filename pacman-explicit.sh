#!/bin/bash
#Displays every package you've explicitly installed, excluding base and base-devel packages.  Very useful for finding packages you don't really want anymore.
pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
