---
description: >-
  Nimble is building the first-ever decentralized AI framework. This guide is
  for educational purposes only. Use at your own risk.
---

# Nimble Network

## Mining Nimble on Ubuntu

Source: [https://github.com/nimble-technology/nimble-wiki](https://github.com/nimble-technology/nimble-wiki)

These instructions are targeted towards those who have a bit of command line experience with Linux.



You can rent a Cloud GPU running Ubuntu 22.04 by using this link: [https://cloud.vast.ai](https://cloud.vast.ai/?ref\_id=94252\&creator\_id=94252\&name=nvidia%2Fcuda%3A12.4.1-devel-ubuntu22.04)\
Set storage size to at least 250GB and use the following configuration:

<figure><img src="../.gitbook/assets/image (5) (1).png" alt=""><figcaption></figcaption></figure>

Update: Check out my step by step [guide](https://x.com/ZachZwei/status/1771400654633992235) from renting a GPU to running the miner (with screenshots).

### Install Tmux

Using [Tmux](https://github.com/tmux/tmux/wiki) will ensure that your session will always run on your machine. To install it (if its not pre-loaded), just run the command:

```
sudo apt install tmux
```

Next, run Tmux to begin setting up your Nimble Wallet and Miner.

```
tmux
```

If you get disconnected from your instance. Just type:

```
tmux a
```

As long as the instance is not restarted, you can always go back to your session with this command.

### Install GO

Before you proceed, check first if Go is installed. Run the following command:

```
go version
```



<figure><img src="../.gitbook/assets/image (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

If you get the prompt above, that means Go 1.22.1 is installed. This is the minimum version required. &#x20;

If you have a lower version or if its not installed then proceed with the next step.

Copy the commands below and run it on your Terminal.

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

Note: &#x20;

(This step is necessary to generate a Nimble address. If you already a master and miner wallets, then you can just skip this step.)

Navigate to the folder where the wallet was installed. Use the following commands.

```
cd
cd go/bin
./nimble-networkd keys add <wallet_name>
```

Type a passphrase, retype it.\
A `nimblexxxx` address will be generated after following the necessary prompts. Save your address and the seed phrase in a secure place. &#x20;

#### Master Wallet (Important)

Generate at least 2 addresses. &#x20;

One of which will be used as your Master Wallet, then other a Miner wallet. &#x20;

Join Nimble Discord to register your addresses: [https://discord.gg/nimble](https://discord.gg/nimble)

<figure><img src="../.gitbook/assets/image (2) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

### Setup Nimble Miner

Note: python3.9 (or above) and pip3 are required for the remaining steps

```
sudo apt update
sudo apt install python3-venv
```

Go back to your Terminal and start building the miner.

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

* Build Errors\
  Having an older version of GO will cause errors in building the wallet and miner.\
  Uninstall GO by running these commands one at a time.

```
sudo apt-get remove golang-go
```

```
sudo apt-get remove --auto-remove golang-go
```

* Update Miner\
  There has been some tasks that are not being completed successfully. Update your miner as soon as possible. \
  Press CTRL + C to stop your miner. Run `git pull` to get the latest version of the miner.\
  Continue mining by running the `make run addr=<wallet_address>`\




\===========

You are now mining $NIM!

For assistance, Join Nimble Discord server - [https://discord.gg/nimble](https://discord.gg/nimble)\
Official website - [https://www.nimble.technology](https://www.nimble.technology/)

