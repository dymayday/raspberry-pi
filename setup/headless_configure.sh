#!/bin/bash

# This is where the magic actually takes place in order to setup
# a 'headless' Raspberry Pi: without X11 or the need to connect a
# keyboard and a screen during first boot.

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# N.B.: The partition part is left to the user for now
DISK1="$1"
DISK2="$2"

# Setting up the headless Raspberry Pi with an Archlinux OS

# Setup the Raspberry Pi's mount point name
BMP="/tmp/raspberrypi_boot"
RMP="/tmp/raspberrypi_root"

mkdir $BMP $RMP
mount $DISK1 $BMP
mount $DISK2 $RMP


# ### Archlinux Arm OS ###
# # Extract the root filesystem
# OSPATH=`ls -t1 $DIR/os/archives/* |  tail -n 1`
# echo ">> Extracting the root filesystem from '${OSPATH}'..."
# bsdtar -xpf $OSPATH -C $RMP
# echo ""
#
# echo ">> Syncing..."
# sync
# echo ""
#
# # Moving around the boot files to the boot partition
# rm -rf $BMP/*
# cp -R $RMP/boot/* $BMP/
#


### Raspbian OS ###
# In case we are using the Raspbian OS, we need to create a special
# file in the boot partition to enable SSH
# Let's enable SSH by default
echo ""
echo ">> Configuring SSH..."
touch $BMP/ssh

# Cleaning up the mess we've done
umount $BMP $RMP
rm -rf $BMP $RMP


# Let's configure our wifi network
echo ""
echo ">> Configuring the wifi network..."
bash $DIR/wifi/wifi_setup.sh $DISK2 Key4CHOUWifi b50c05b37b

