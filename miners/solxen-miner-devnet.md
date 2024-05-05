---
description: Shaking up rusty Solana
---

# SolXEN Miner (DevNet)

**Disclaimer!**&#x20;

Not Financial Advise. Educational purposes only.&#x20;

This is running purely on [Solana DevNet](https://explorer.solana.com/?cluster=devnet).

Tested on a 20-Core CPU server with Ubuntu 22.04.

Official site: [https://github.com/FairCrypto/sol-xen](https://github.com/FairCrypto/sol-xen)



### Install Solana CLI

This will be used to generate your wallet.

Run the following command:

```
sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"
```



### Generate a wallet

Run the following command:

```
solana-keygen new
```

<figure><img src="../.gitbook/assets/image (3) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

This will generate a new keypair and save it on the `.config` directory.&#x20;

Take note of this directory which will be used later.

### Get SOL Devnet Tokens

Go here [https://faucet.solana.com/](https://faucet.solana.com/) and Enter your SOL address.

Make sure that you are requesting **Devnet** tokens.

If you have a GitHub account, you can request more tokens.

<figure><img src="../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

### Install SolXEN miner

You need to have latest `node.js` installed before you proceed. Run the following command.

```
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Check if the install was successful by typing `node --version`.

Next, clone the SolXEN repository:

```
git clone https://github.com/FairCrypto/sol-xen.git
cd sol-xen
```

Run the following commands to initialize the miner:

```
npm install
npm i
npm i -g tsx
```

### Configure miner

Create a `.env` file:

```
nano .env
```

Paste the following and the save file. Make sure to set the correct path for your SOL wallet

```
USER_WALLET=../.config/solana/id.json
ANCHOR_PROVIDER_URL=https://api.devnet.solana.com
DEBUG=*
```

In my case, the miner was located at `/.config/solana`.&#x20;

### Run SolXEN miner

Replace the ETH address with your own. This is where you will get your XN Airdrop once that is released.

```
node ./client/miner.js mine --address <ETH address> -fee 1
```

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

The command will submit a transaction and will attempt to find a `420` or a `42069` hash.

To run the miner multiple times, just add a `-r` at the end and specify the number of runs.

```
node ./client/miner.js mine --address <ETH address> -fee 1 -r 1000
```

This will continuously run the miner until the number of attempts runs out.

<figure><img src="../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

You can check the transactions here: [https://explorer.solana.com/?cluster=devnet](https://explorer.solana.com/?cluster=devnet)

Just search for your address and then tap on a transaction to review it.

<figure><img src="../.gitbook/assets/image (15).png" alt=""><figcaption></figcaption></figure>

Check your SolXEN tokens by going to the Tokens tab of the explorer.

<figure><img src="../.gitbook/assets/image (16).png" alt=""><figcaption></figcaption></figure>

Join SoLXEN Telegram: [https://t.me/+rrWU85yki-k3MzRj](https://t.me/+rrWU85yki-k3MzRj)
