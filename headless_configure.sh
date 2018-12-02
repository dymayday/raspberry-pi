#!/bin/bash

# This is where the magic actually takes place in order to setup
# a 'headless' Raspberry Pi: without X11 or the need to connect a
# keyboard and a screen during first boot.

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Let's configure our wifi network
echo ">> Configuring the wifi network..."
bash $DIR/wifi/configure.sh

# Let's enable SSH by default
echo ">> Configuring SSH..."
