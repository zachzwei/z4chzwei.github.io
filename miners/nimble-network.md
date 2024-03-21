---
description: >-
  Nimble is building the first-ever decentralized AI framework. This guide is
  for educational purposes only. Use at your own risk.
---

# Nimble Network

## Mining Nimble on Ubuntu

Source: [https://github.com/nimble-technology/nimble-wiki](https://github.com/nimble-technology/nimble-wiki)

These instructions are targeted towards those who have a bit of command line experience with Linux.

You can rent a Cloud GPU running Ubuntu 22.04 by using this link: [https://cloud.vast.ai/?ref\_id=94252](https://cloud.vast.ai/?ref\_id=94252)

### Install GO

Get the link of the latest version here: [https://go.dev/dl/](https://go.dev/dl/) or just copy the commands below.

```
sudo apt update
wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

Check the Go version that was installed.

```
go version
```

It should display the go version 1.22.1.

### Install Nimble’s Wallet CLI

Note: Git is required to copy the Github repo of Nimble.

```
sudo apt install git
mkdir $HOME/nimble && cd $HOME/nimble
git clone https://github.com/nimble-technology/wallet-public.git
cd wallet-public
make install
```

### Generate a Nimble Wallet

```
cd
cd go/bin
./nimble-networkd keys add <wallet_name>
```

Type a passphrase, retype it.\
A `nimblexxxx` address will be generated after following the necessary prompts. Save your address and the seed phrase in a secure place.

### Setup Nimble Miner

Note: python3.9 (or above) and pip3 are required for the remaining steps

```
sudo apt update
sudo apt install python3-venv
```

Build the miner

```
cd
cd nimble
git clone https://github.com/nimble-technology/nimble-miner-public.git
cd nimble-miner-public
make install
```

Activate the miner

```
source ./nimenv_localminers/bin/activate
```

### Run Nimble Miner

Copy the Nimble address generated from the Nimble wallet. Replace the \<wallet\_address> on the command below.

```
make run addr=<wallet_address>
```

You can stop the miner by pressing CTRL+C\
To resume mining, re-run the command.



### Troubleshooting

Having an older version of GO will cause errors in building the wallet and miner.\
Uninstall GO by running these commands one at a time.

```
sudo apt-get remove golang-go
```

```
sudo apt-get remove --auto-remove golang-go
```

\===========

You are now mining NIM!

For assistance, Join Nimble Discord server - [https://discord.gg/nimble](https://discord.gg/nimble)\
Official website - [https://www.nimble.technology](https://www.nimble.technology/)

