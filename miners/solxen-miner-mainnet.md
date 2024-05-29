---
description: Shaking up rusty Solana
---

# SolXEN Miner (Mainnet)

## **Disclaimer!**&#x20;

Not Financial Advise. Educational purposes only.&#x20;

Source: [https://github.com/FairCrypto/sol-xen](https://github.com/FairCrypto/sol-xen)

This miner is designed to utilize all Solana threads which was not possible on Devnet (also Mainnet) Solana. This guide has 2 versions of the miner, namely Node.js (Simple) and Rust (Advanced). You can install all requirements needed if you want.&#x20;



This is now the live SolXEN on Solana Mainnet-Beta.\
Token Contract: [EEqrab5tdnVdZv7a4AUAvGehDAtM8gWd7szwfyYbmGkM](https://solscan.io/token/EEqrab5tdnVdZv7a4AUAvGehDAtM8gWd7szwfyYbmGkM)

Trade on Raydium: [https://raydium.io/swap/?inputMint=sol\&outputMint=EEqrab5tdnVdZv7a4AUAvGehDAtM8gWd7szwfyYbmGkM](https://raydium.io/swap/?inputMint=sol\&outputMint=EEqrab5tdnVdZv7a4AUAvGehDAtM8gWd7szwfyYbmGkM)





## Create SOL Wallets

### Install Solana CLI

This will be used to generate your wallet.

Run the following command:

```
sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"
```

Make sure that you are connecting to Solana Mainnet:

```
solana config set --url https://api.mainnet-beta.solana.com
```

### Generate wallets

Run the following command:

**Remember to backup your seed phrase. If you lose this, you will lose access to your wallet.**

```
solana-keygen new --derivation-path --no-passphrase -o ~/.config/solana/id0.json
```

<figure><img src="../.gitbook/assets/image (18).png" alt="" width="563"><figcaption></figcaption></figure>

This will generate a new keypair and save it on the `.config` directory.&#x20;

Take note of this directory which will be used later.

Run the command again while replacing the file name (idx.json) to generate a total of 4 addresses.

```
solana-keygen new --derivation-path --no-passphrase -o ~/.config/solana/id1.json
solana-keygen new --derivation-path --no-passphrase -o ~/.config/solana/id2.json
solana-keygen new --derivation-path --no-passphrase -o ~/.config/solana/id3.json
```

You now have 4 Solana wallets namely, id0.json, id1.json, id2.json and id3.json that are located at the `/.config/solana/` folder.\


**Remember to backup your seed phrase. If you lose this, you will lose access to your wallet.**

### Fund your SOL addresses

Buy or Get Solana from exchanges. There is no free airdrops.

## Choose a Miner

You can run a Simple miner or an Advanced miner. The only difference is that a Simple miner will can be run on a single terminal utilizing all 4 wallets. Unlike with an Advanced miner where you need to individuall run separate miners for each wallet. You can install all pre-requisites below or just choose which ever miner you want to run.

### Install Nodejs (Simple miner) <a href="#install-nodejs" id="install-nodejs"></a>

You need to have latest `node.js` installed before you proceed. Run the following command.

Copy

```
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Check if the install was successful by typing `node --version`.

### Install Rust (Advanced miner)

```
cd
curl https://sh.rustup.rs -sSf | sh
```

Set path

```
source $HOME/.cargo/env
```

Update Rust

```
rustup update
```

## Setup SolXEN Miner

### Clone SolXen miner

Clone the SolXEN repository:

```
git clone https://github.com/FairCrypto/sol-xen.git
cd sol-xen
```

### Configure miner

Create a `.env` file:

```
nano .env
```

Paste the following and the save file. Make sure to set the correct path for your SOL wallet.

```
USER_WALLET_PATH=../.config/solana/
ANCHOR_PROVIDER_URL=https://api.mainnet-beta.solana.com
```

Save the file.

#### Note:

Since this is the mainnet version, you will be competing with other transactions being submitted on the Solana network. The RPC provided below "https://api.mainnet-beta.solana.com" is a public (free) Solana RPC. You can sign up to paid ones if you want to get a dedicated RPC for your miner.\
Check here: [https://x1.wiki/#solxen-tools](https://x1.wiki/#solxen-tools)

## Run SolXEN miner

### SolXEM miner (Easy Miner)

This allows you to mine SolXEN on a single session. It will utilize all 4 wallets created.

After installing Node.js, run:

```
npm i
```

Run miner:

```
node ./client/multiminer.js mine --address <ETH Address> --f 10000 --delay 1 --units 1150000 --autoMint 1000
```

Make sure to set your own ETH address.

Congratulations, you are now mining SolXen.

Note:

The "--f" setting tells your miner what priority fee you want to use. You can always check the recommended values here:\
[https://www.quicknode.com/gas-tracker/solana](https://www.quicknode.com/gas-tracker/solana)

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>



### Run SolXEN miner (Advanced)

These commands need to be run individually on each separate terminal or session (via tmux).

Use your own ETH address for every command.

\---

Notice that the id0.json file is being used here and --kind 0 is set for this miner.

```
export USER_WALLET=../.config/solana/id0.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 0 --fee 100000; sleep 10; done
```

Notice that the id1.json file is being used here and --kind 1 is set for this miner.

```
export USER_WALLET=../.config/solana/id1.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 1 --fee 100000; sleep 10; done
```

Notice that the id2.json file is being used here and --kind 2 is set for this miner.

```
export USER_WALLET=../.config/solana/id2.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 2 --fee 100000; sleep 10; done
```

Notice that the id3.json file is being used here and --kind 3 is set for this miner.

```
export USER_WALLET=../.config/solana/id3.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 3 --fee 100000; sleep 10; done
```

This is how it would look like if you are using tmux to run 4 separate sessions.

<figure><img src="../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

#### Mint SolXEN token (for Advanced miner)

The token needs to be minted manually. Open up a new terminal and run the following commands individually for every wallet id and --kind instance. Make sure to set the same ETH address as your miners.

```
export USER_WALLET=../.config/solana/id0.json # change the path if necessary

cargo run --package sol-xen-client -- --address <ETH address> --command mint --kind 0
```

```
export USER_WALLET=../.config/solana/id1.json # change the path if necessary

cargo run --package sol-xen-client -- --address <ETH address> --command mint --kind 1
```

```
export USER_WALLET=../.config/solana/id2.json # change the path if necessary

cargo run --package sol-xen-client -- --address <ETH address> --command mint --kind 2
```

```
export USER_WALLET=../.config/solana/id3.json # change the path if necessary

cargo run --package sol-xen-client -- --address <ETH address> --command mint --kind 3
```

<figure><img src="../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>

## Check Leaderboard

Check your current miner rank here: [https://solxen.io/leaderboard](https://solxen.io/leaderboard)

<figure><img src="../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>

## Check Balance on Phantom

To view your SolXEN balance, you need to import your address to [Phantom](https://phantom.app/download).&#x20;

Navigate to your Solana config directory.

Then type:

```
cat idx.json
```

Replace "x" with the wallet id that you want to get the keypair.

You will see a set of numbers separated by commas.

<figure><img src="../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

Copy the entire contents of the idx.json file including the \[ ]. Paste it on the Import Private Key screen of Phantom to restore the wallet.



<figure><img src="../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

If you have done that correctly, you will be able to restore your address and all balances will be shown.

<figure><img src="../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

Note:\
The screenshot above shows there are 2 SolXEN tokens. The first token was not transferrable, and thus cannot be trade. Make sure you are running the updated miner. To do so, simple stop your miner and run the following command:

```
git pull
```

Then run your miner again.

## References

* Thanks to [xen\_artist](https://twitter.com/xen\_artist) for his [guide](https://x1.wiki/solxen/).
* Join SoLXEN Telegram: [https://t.me/+rrWU85yki-k3MzRj](https://t.me/+rrWU85yki-k3MzRj)
* Follow [https://x.com/mrJackLevin](https://x.com/mrJackLevin) on X
