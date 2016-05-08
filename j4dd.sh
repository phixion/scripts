#!/bin/sh
j4-dmenu-desktop --dmenu="(cat ; (stest -flx $(echo $PATH | tr : ' ') | sort -u)) | dmenu -fn 'Ohsnapu-10' -nb '#2F343F' -nf '#9fbc00' -sb '#9fbc00' -sf '#2F343F' -l 10 -i" --term="i3-sensible-terminal"
