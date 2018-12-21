# SS-Client

This repository is about building from scratch a headless generic data gathering device in Rust using a Raspberry Pi.

## Usage

At the moment, we are still not cross-compiling this program and so we still need *Cargo* and the Rust compiler.
Run this command to compile the program.

```bash
cargo build --release
```

And it will install the programs we need (git, vim, etc.) and configure them.

## Headless setup

In order to setup a *headless* Raspberry Pi with Raspbian OS, just copy the file [ss-client.service](file:://ss-client.service) to `/etc/systemd/system/ss-client.service` and run the following on the Raspberry Pi (the real headless setup will come when the dev of the all system is done):
```bash
sudo systemctl daemon-reload
sudo systemctl restart ss-client.service
```
