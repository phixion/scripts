#!/bin/bash
rightpic=$RANDOM
leftpic=$RANDOM
wget -q https://source.unsplash.com/random/2560x1440 -O /tmp/"$leftpic".jpeg
wget -q https://source.unsplash.com/random/1080x1920 -O /tmp/"$rightpic".jpeg
feh --bg-fill /tmp/"$leftpic".jpeg /tmp/"$rightpic".jpeg