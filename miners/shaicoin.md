---
description: >-
  Shaicoin is a  CPU mineable cryptocurrency that operates as a fork of Bitcoin,
  focusing on a unique mining algorithm known as ShaiHive.  The following guide
  is for those who are familiar running Linux
---

# Shaicoin

Disclaimer:\
This is not financial advise. Mining can damage your hardware.



### Get Started

This guide is purely made for those who wants to try mining [$SHA](https://x.com/search?q=%24SHA\&src=cashtag\_click) with their Linux machines. \
Do not have a Linux computer or spare CPU to mine? \
Rent one here: [https://cloud.vast.ai/?ref\_id=94252](https://t.co/BgNghk4FL4)

The steps involved include:&#x20;

\* Setting up a Shaicoin Core Wallet&#x20;

\* Generating a [$SHA](https://x.com/search?q=%24SHA\&src=cashtag\_click) address&#x20;

\* Building [$SHA](https://x.com/search?q=%24SHA\&src=cashtag\_click) miner&#x20;

\* Connecting to a mining pool

### Setting up Core Wallet

On your Terminal, run the following commands:

#### Install dependencies

```
sudo apt install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-dev libsqlite3-dev -y
```

<figure><img src="../.gitbook/assets/image (58).png" alt=""><figcaption></figcaption></figure>

#### Clone the repo

```
git clone https://github.com/shaicoin/shaicoin  
cd shaicoin
```

<figure><img src="../.gitbook/assets/image (59).png" alt=""><figcaption></figcaption></figure>

#### Build the wallet

```
./autogen.sh
./configure
```

<figure><img src="../.gitbook/assets/image (60).png" alt=""><figcaption></figcaption></figure>

Depending on the number of CPU cores of your machine, the next command will require you to indicate that number. The build process might take a while. Please be patient.

```
# example make -j8
make -jmake -j [# CPU cores]
```

<figure><img src="../.gitbook/assets/image (61).png" alt=""><figcaption></figcaption></figure>

### Run Core Wallet and Sync

#### Run Wallet

Navigate to the `/src` folder and then run the following command to launch the core wallet in the background.

```
./shaicoind -daemon
```

<figure><img src="../.gitbook/assets/image (62).png" alt=""><figcaption></figcaption></figure>

#### Check Logs

To view the logs navigate to the `.shaicoin` folder.

```
cd
cd .shaicoin
```

Next, run this command.

```
tail -f debug.log
```

<figure><img src="../.gitbook/assets/image (63).png" alt=""><figcaption></figcaption></figure>

Wait for your core wallet to fully sync before you proceed to the next step.

To check the current block, go here: [https://blocks.shaicoin.com](https://t.co/OSFKwpJ5IO). Compare the "height" value shown on the logs to the most recent block on the Shaicoin block explorer.

<figure><img src="../.gitbook/assets/image (65).png" alt=""><figcaption></figcaption></figure>

### Generate Wallet&#x20;

Navigate to `/shaicoin/src` folder:&#x20;

```
cd
cd shaicoin
cd src 
```

Then run the command to generate a wallet:&#x20;

```
./shaicoin-cli createwallet "yourwalletname" 
```

You can put in a wallet name that you like.&#x20;

Next, generate a [$SHA](https://x.com/search?q=%24SHA\&src=cashtag\_click) address: &#x20;

```
./shaicoin-cli getnewaddress
```

Take note of the address since this will be used for your miner.

<figure><img src="../.gitbook/assets/image (66).png" alt=""><figcaption></figcaption></figure>

### Backup Wallet

Always make a backup of your wallet. Here is how to do it.&#x20;

Go back to the `.shaicoin` folder to see your wallet backup.

```
cd
cd .shaicoin
cd wallets
```

<figure><img src="../.gitbook/assets/image (67).png" alt=""><figcaption></figcaption></figure>

Save the contents of the folder in order to restore your wallet in case you need to move to a different machine.



### Build [$SHA](https://x.com/search?q=%24SHA\&src=cashtag\_click) miner&#x20;

#### Install dependencies

```
apt install libssl-dev
```

<figure><img src="../.gitbook/assets/image (68).png" alt=""><figcaption></figcaption></figure>

#### Install Rust&#x20;

Run the following command:&#x20;

```
curl https://sh.rustup.rs -sSf | sh
```

&#x20;Then choose option "1". Once it is done, set the PATH:&#x20;

```
source "$HOME/.cargo/env"
```

<figure><img src="../.gitbook/assets/image (69).png" alt=""><figcaption></figcaption></figure>

#### Clone Shaipot miner&#x20;

```
cd
git clone https://github.com/shaicoin/shaipot.git
cd shaipot
```

<figure><img src="../.gitbook/assets/image (70).png" alt=""><figcaption></figcaption></figure>

#### Build miner

Run the following command:&#x20;

```
cargo rustc --release -- -C opt-level=3 -C target-cpu=native -C codegen-units=1 -C debuginfo=0
```

### Run the SHA miner

Get your [$SHA](https://x.com/search?q=%24SHA\&src=cashtag\_click) address that you have generated and use that for the command to run your miner. You can follow this format:

```
./target/release/shaipot --address sh1xxxxxxxxxxxxxj --pool ws://162.220.160.74:3333
```

Make sure to change the address, or else your mining rewards will go to me.&#x20;

<figure><img src="../.gitbook/assets/image (72).png" alt=""><figcaption></figcaption></figure>

Run the command and that is it. You are now mining [$SHA](https://x.com/search?q=%24SHA\&src=cashtag\_click).

Check your progress here: [https://shaipool.z4ch.xyz/](https://shaipool.z4ch.xyz/)

Pool address: [https://blocks.shaicoin.com/address/sh1qa5l9n97jerlwgpd5rrhj8nnqvvre4qnz0dy2fu](https://blocks.shaicoin.com/address/sh1qa5l9n97jerlwgpd5rrhj8nnqvvre4qnz0dy2fu)

<figure><img src="../.gitbook/assets/image (71).png" alt=""><figcaption></figcaption></figure>

Rewards will automatically be distributed once the coins that the pool receives reaches a maturity of a 100 blocks.

Thanks for reading!



Follow [@shai\_pow](https://x.com/shai\_pow) on X and go to their Discord: [https://discord.gg/vrfvbrDU](https://t.co/8INwdtdfhf)















