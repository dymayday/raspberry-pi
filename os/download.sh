#!/bin/bash

# Archlinux section
OSNAME="ArchLinuxARM-rpi-3-latest.tar.gz"
curl -L http://os.archlinuxarm.org/os/${OSNAME} --output archives/${OSNAME}

exit

# Rasbian section
OSNAME="raspbian_lite_latest"
curl -Lk https://downloads.raspberrypi.org/${OSNAME} --output archives/${OSNAME}.zip
