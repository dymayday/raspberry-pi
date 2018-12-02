#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ARCHIVES_DIR="${DIR}/archives"

# Archlinux section
OSNAME="ArchLinuxARM-rpi-3-latest.tar.gz"
curl -L http://os.archlinuxarm.org/os/${OSNAME} --output ${ARCHIVES_DIR}/${OSNAME}

# For the time being, we will only focus on the 'Archlinux' OS
exit

# Rasbian section
OSNAME="raspbian_lite_latest"
curl -Lk https://downloads.raspberrypi.org/${OSNAME} --output ${ARCHIVES_DIR}/${OSNAME}.zip
