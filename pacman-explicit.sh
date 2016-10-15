#!/bin/bash
#Displays every package you've explicitly installed, excluding base and base-devel packages.  Very useful for finding packages you don't really want anymore.
pacman -Qei | awk '/^Name/ { name=$3 } /^Groups/ { if ( $3 != "base" && $3 != "base-devel" ) { print name } }'
