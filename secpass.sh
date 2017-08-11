#!/bin/bash

# quickly create 20 passwords

cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 20