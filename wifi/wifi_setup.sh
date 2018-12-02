#!/bin/sh

# This script is adapted from https://ladvien.com/installing-arch-linux-raspberry-pi-zero-w/

set -e

# Setup the Raspberry Pi's mount point name
RMP="/tmp/raspberrypi_root"

if [[ $# -ne 3 ]] ; then
   echo "Usage: $0 </dev/disk> <ssid> <passphase>"
   exit 1
fi

DISK="$1"
SSID="$2"
PASS="$3"

if [[ ! -b "${DISK}" ]] ; then
   echo "Not a block device: ${DISK}"
   exit 1
fi

if [[ "${USER}" != "root" ]] ; then
   echo "Must run as root."
   exit 1
fi

echo "Mounting"
mkdir $RMP
mount "${DISK}2" $RMP

cat << EOF >> ${RMP}/etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

wpa_passphrase "${SSID}" "${PASS}" > $RMP/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

ln -s \
   /usr/lib/systemd/system/wpa_supplicant@.service \
   $RMP/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service

echo "Unmounting"
umount $RMP

echo "Cleaning up"
rmdir $RMP
