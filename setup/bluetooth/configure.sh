#!/bin/bash

# Setting up the Bluetooth capability of a Raspberry Pi to handle
# headless "SSH" like connection at first boot
# We will mostly follow the link https://hacks.mozilla.org/2017/02/headless-raspberry-pi-configuration-over-bluetooth/
# in ordder to achieve our magnificent goal.

set -e

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# First, we need to mount the Raspberry Pi file system of the sd card.

# N.B.: The partition part is left to the user for now
DISK1="${1:-/dev/mmcblk0p1}"
DISK2="${2:-/dev/mmcblk0p2}"
SSID="${3:-Key4CHOUWifi}"
WPAPASS="${4:-b50c05b37b}"

# Setting up the headless Raspberry Pi with an Archlinux OS

# Setup the Raspberry Pi's mount point name
BMP="/tmp/raspberrypi_boot"
RMP="/tmp/raspberrypi_root"

mkdir $BMP $RMP
mount $DISK1 $BMP
mount $DISK2 $RMP

# Copy the Bluetooth configuration file to the Raspberry Pi's root file system.
cp $DIR/btserial.sh $RMP/usr/bin/btserial.sh
chmod 755 $RMP/usr/bin/btserial.sh

# Making the previous script run on startup
grep -q -F '#Launch bluetooth service startup' /etc/rc.local || sed -ier "x;${s/exit 0$//;p;x;};1d" /etc/rc.local && echo "sudo /home/pi/btserial.sh &\nexit 0" >> /etc/rc.local

# Let's make sure everything is writen
echo ">> Syncing..."
sync
echo ""

# Cleaning up the mess we've done
umount $BMP $RMP
rm -rf $BMP $RMP
