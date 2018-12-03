#!/bin/sh

# This script is adapted from https://ladvien.com/installing-arch-linux-raspberry-pi-zero-w/

set -e

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Setup the Raspberry Pi's mount point name
RMP="/tmp/raspberrypi_root"

# Let's check if we passed the rigt number of argument
if [[ $# -ne 3 ]] ; then
   echo "Usage: $0 </dev/disk> <ssid> <passphase>"
   exit 1
fi

DISK="$1"
SSID="$2"
PASS="$3"

# Let's check if the disk exists
if [[ ! -b "${DISK}" ]] ; then
   echo "Not a block device: ${DISK}"
   exit 1
fi

# Let's check if we run this script as 'root'
if [[ "${USER}" != "root" ]] ; then
   echo "Must run as root."
   exit 1
fi

echo "Mounting"
mkdir $RMP
mount "${DISK}" $RMP

# Fill in the wifi card network configuration
cat << EOF >> ${RMP}/etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

# cp $DIR/wlan0.network ${RMP}/etc/systemd/network/
cat ${RMP}/etc/systemd/network/wlan0.network

# This is where we actually connect to the wifi access point
wpa_passphrase "${SSID}" "${PASS}" > $RMP/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
cat $RMP/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

# Not sure what this is about here
[ ! -s /usr/lib/systemd/system/wpa_supplicant@.service ] && ln -s \
   /usr/lib/systemd/system/wpa_supplicant@.service \
   $RMP/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service



# Let's make sure everything is writen
echo ">> Syncing..."
sync
echo ""

# Let's clean up the mess
echo "Unmounting"
umount $RMP

echo "Cleaning up"
rmdir $RMP
