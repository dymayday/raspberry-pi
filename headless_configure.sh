#!/bin/bash

# This is where the magic actually takes place in order to setup
# a 'headless' Raspberry Pi: without X11 or the need to connect a
# keyboard and a screen during first boot.

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# N.B.: The partition part is left to the user for now
DISK="$1"

# Setting up the headless Raspberry Pi with an Archlinux OS

# Setup the Raspberry Pi's mount point name
RMP="/tmp/raspberrypi_root"

mkdir $RMP
mount $DISK $RMP

# Extract the root filesystem
bsdtar -xpf $DIR/os/archives/* -C $RMP

# Flash the bootloader files
cd $RMP/boot
./sd_fusing.sh $DISK
cd -

# Cleaning up the mess we've done
umount $RMP
rmdir $RMP

# Let's configure our wifi network
echo ">> Configuring the wifi network..."
bash $DIR/wifi/configure.sh $DISK Key4CHOUWifi b50c05b37b

# Let's enable SSH by default
echo ">> Configuring SSH..."
