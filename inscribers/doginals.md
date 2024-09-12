---
description: A minter and protocol for inscriptions on Dogecoin.
---

# Doginals



#### ⚠️⚠️⚠️ Important ⚠️⚠️⚠️

Use this wallet for inscribing only! Always inscribe from this wallet to a different address, e.g. one you created with DogeLabs or Doggy Market. This wallet is not meant for storing funds or inscriptions.

## Prerequisites

This guide requires a bit of coding knowledge and running Ubuntu on your local machine or a rented one. To use this, you'll need to use your terminal to setup a Dogecoin node, clone this repo and install Node.js on your computer.

### Setup Dogceoin node

Follow the instructions here to setup and sync your Dogecoin node: (https://dogecoin.com/dogepedia/how-tos/operating-a-node/#linux-instructions)

#### ⚠️⚠️⚠️ Important ⚠️⚠️⚠️

A configuration file needs to be created before you continue with the sync. Stop your node:

```
./dogecoin-cli stop
```

Create a `dogecoin.conf` file at `/root/.dogecoin` folder. Set your own username/password.

```
nano dogecoin.conf
```

Copy and paste this to the created file. Save it!

```
rpcuser=ape
rpcpassword=zord
rpcport=22555
server=1
listen=1
txindex=1
rpcallowip=127.0.0.1
```

Start your node again

```
./dogecoind -daemon
```

How to check if your node is in sync with the network. On your `dogecoin` install folder, type the command `dogecoin-cli getinfo`

Compare the "blocks" value to the current block height via a Dogecoin explorer like: https://sochain.com/DOGE Do not mint anything yet unless your node is fully synced. You can proceed with installing the other requirements below.

\==========

### Install NodeJS

Please head over to (https://github.com/nodesource/distributions#using-ubuntu) and follow the installation instructions.

```
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Check if they are installed by running the following commands:

```
node -v
```

v21.6.2

```
npm -v
```

10.2.4

These recent verions works with this minter.

**Cannot install Nodejs?**

If you are having trouble installing the latest version, remove nodejs and npm by using these commands.

```
sudo apt-get remove nodejs
sudo apt-get remove npm
npm list -g --depth=0
sudo apt-get autoremove
```

The `node-v` and `npm-v` commands should show an error that they are not installed. Procced with the install instructions above.

\==========

## Setup Shibescriptions

### **Clone Doginal minter**

On your Terminal, type the following commands:

```
cd
git clone https://github.com/zachzwei/doginals.git
```

### **Setup minter**

```
cd doginals
npm i
```

After all dependencies are solved, you can configure the environment:

### **Configure environment**

Create a `.env` file with your node information. Set your own username/password.

```
NODE_RPC_URL=http://127.0.0.1:22555
NODE_RPC_USER=ape
NODE_RPC_PASS=zord
TESTNET=false
FEE_PER_KB=69000000
```

You can get the current fee per kb from [here](https://blockchair.com/).

\==========

**⚠️⚠️⚠️ Important ⚠️⚠️⚠️**

### Before proceeding, please make sure your node is fully synced. Have fun!

## Creating a New Core Wallet

We will now create a new wallet on your Dogecoin node. Navigate to the install folder where you have extracted the files.

```
cd dogecoin-1.14.7
cd bin
```

Genereate new address with this command:

```
./dogecoin-cli getnewaddress <wallet name>
```

Example: `./dogecoin-cli getnewaddress z4ch`

Next, get the Private Key of this new address

```
./dogecoin-cli dumpprivkey <dogecoin address>
```

Example: `./dogecoin-cli dumpprivkey DCJPoswVPpctoaBSBcapVfkPPMwhFT7PPV`

Take note of the Private Key of the address. We will use this on the next step.

### Create Doginal Wallet

Navigate to the Doginals folder:

```
cd
cd doginals
```

Generate the .wallet.json file:

```
node . wallet new
```

Modify .wallet.json file:

```
nano .walet.json
```

Replace the DOGE Address and Private Key on this file and then save it.

You can now send some DOGE to this new address.

### Sync Balance with Core

Run the following command on your Doginals folder:

```
node . wallet sync
```

If your balance is shown, then you can proceed with minting some Doginals.

\==========

## Minting Doginals

**Note**: Please use a fresh wallet to mint to with nothing else in it until proper wallet for doginals support comes. You can get a paper wallet [here](https://www.fujicoin.org/wallet\_generator?currency=Dogecoin).

### **Inscribe a file**

From file:

```
node . mint <address> <path>
```

From data:

```
node . mint <address> <content type> <hex data>
```

Examples:

```
node . mint DSV12KPb8m5b6YtfmqY89K6YqvdVwMYDPn dog.jpeg
```

```
node . mint DSV12KPb8m5b6YtfmqY89K6YqvdVwMYDPn "text/plain;charset=utf-8" 576f6f6621 
```

### **Lazy image minter**

This script will allow you to mint and forger large files. Make sure your Doge wallet has enough funds before proceeding.

Make `image-mint.sh` executable

```
chmod +x image-mint.sh
```

Run the script with additional parameters

```
./image-mint.sh <address> <filename>
```

Example: ./image-mint.sh \<doom.jpg>

**Incribing DRC-20**

```
node . drc-20 mint <address> <ticker> <amount>
```

Examples:

```
node . drc-20 mint DSV12KPb8m5b6YtfmqY89K6YqvdVwMYDPn dogi 1000
```

### **DRC-20 bulk minter**

This script will allow you to bul mint a DRC-20. Make sure your Doge wallet has enough funds before proceeding.

Make `bulk-mint.sh` executable

```
chmod +x bulk-mint.sh
```

Run the script with additional parameters

```
./bulk-mint.sh <max_count> <target_address> <token_name>
```

Example: ./bulk-mint.sh <100> Check the max token count you can mint for the specific token.

### Viewing Doginals

Start the server:

```
node . server
```

And open your browser to:

```
http://localhost:3000/tx/15f3b73df7e5c072becb1d84191843ba080734805addfccb650929719080f62e
```

\==========

### Additional Info

**Protocol**

The doginals protocol allows any size data to be inscribed onto subwoofers.

An inscription is defined as a series of push datas:

```
"ord"
OP_1
"text/plain;charset=utf-8"
OP_0
"Woof!"
```

For doginals, we introduce a couple extensions. First, content may spread across multiple parts:

```
"ord"
OP_2
"text/plain;charset=utf-8"
OP_1
"Woof and "
OP_0
"woof woof!"
```

This content here would be concatenated as "Woof and woof woof!". This allows up to \~1500 bytes of data per transaction.

Second, P2SH is used to encode inscriptions.

There are no restrictions on what P2SH scripts may do as long as the redeem scripts start with inscription push datas.

And third, inscriptions are allowed to chain across transactions:

Transaction 1:

```
"ord"
OP_2
"text/plain;charset=utf-8"
OP_1
"Woof and "
```

Transaction 2

```
OP_0
"woof woof!"
```

With the restriction that each inscription part after the first must start with a number separator, and number separators must count down to 0.

This allows indexers to know how much data remains.

## Troubleshooting

**I'm getting ECONNREFUSED errors when minting**

There's a problem with the node connection. Your `dogecoin.conf` file should look something like:

```
rpcuser=ape
rpcpassword=zord
rpcport=22555
server=1
```

Make sure `port` is not set to the same number as `rpcport`. Also make sure `rpcauth` is not set.

Your `.env file` should look like:

```
NODE_RPC_URL=http://127.0.0.1:22555
NODE_RPC_USER=ape
NODE_RPC_PASS=zord
TESTNET=false
```

**I'm getting "insufficient priority" errors when minting**

The miner fee is too low. You can increase it up by putting FEE\_PER\_KB=300000000 in your .env file or just wait it out. The default is 100000000 but spikes up when demand is high.

**Other issues**

Try restarting your Dogecoin node. Stop your node by going to the `bin` folder and type the following command: `./dogecoin-cli stop`

Always make sure that the requirements are met.

If still stuck, ask ChatGPT or search online for other solutions.

\==========

### Screenshots

* Checking `node` and `npm` versions
* Cloning repository `git clone https://github.com/zachzwei/doginals.git`
* Running `npm install`
* Generating a new wallet `node . wallet new`

![image](https://github.com/zachzwei/doginals/assets/35627271/283acfe4-ce3e-4987-98f5-af195ed2dbb6)

* Checking wallet balance after sending some ÐOGE. `node . wallet sync`

![image](https://github.com/zachzwei/doginals/assets/35627271/c827ec11-e1ba-4203-aa31-0b8e34e062b5)

* Creating `.env` file and viewing it.

![image](https://github.com/zachzwei/doginals/assets/35627271/56d96d02-d4c1-4bfe-8a7d-c4aa341cf655)

* Test mint of an image

![image](https://github.com/zachzwei/doginals/assets/35627271/d71f0fa9-1f0b-4bcc-8695-6d3fda697467)
