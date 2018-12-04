# raspberry-pi

This repository concentrate all the thing I need during my enddever into the 'Raspberry Pi' world and the IOT in general 

## Usage

In order to install and setting up everything we need for a happy environnement of development just run:

```bash
bash setup/install.sh
```

And it will install the programs we need (git, vim, etc.) and configure them.

## Headless Raspberry Pi

In order to setup a *headless* Raspberry Pi with Raspbian OS, we only need to run the `headless_configure.sh` script as *root* as follow:
```bash
bash setup/headless_configure.sh /dev/mmcblk0p1 /dev/mmcblk0p2
```
