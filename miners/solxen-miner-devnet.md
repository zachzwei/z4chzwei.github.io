---
description: Shaking up rusty Solana
---

# SolXEN Miner (DevNet)

**Disclaimer!**&#x20;

Not Financial Advise. Educational purposes only.&#x20;

This is running purely on [Solana DevNet](https://explorer.solana.com/?cluster=devnet).

Tested on a bare metal server with Ubuntu 22.04.

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

<figure><img src="../.gitbook/assets/image (18).png" alt="" width="563"><figcaption></figcaption></figure>

This will generate a new keypair and save it on the `.config` directory.&#x20;

Take note of this directory which will be used later.

### Get SOL Devnet Tokens

Go here [https://faucet.solana.com/](https://faucet.solana.com/) and Enter your SOL address.

Make sure that you are requesting **Devnet** tokens.

If you have a GitHub account, you can request more tokens.

<figure><img src="../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

### Install Nodejs

You need to have latest `node.js` installed before you proceed. Run the following command.

```
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Check if the install was successful by typing `node --version`.

### Install SolXen miner

Next, clone the SolXEN repository:

```
git clone https://github.com/FairCrypto/sol-xen.git
cd sol-xen
```

Run the following commands to initialize the miner:

```
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

Make sure that you are on the SolXen `delta` branch. To check run the following commands.

```
git stash
git checkout delta
git pull
```

You should see something like this:

<figure><img src="../.gitbook/assets/image (33).png" alt=""><figcaption></figcaption></figure>

Run the following command to start mining SolXen.\
Please take note of the following variables:

\--runs \<number> - represents the number of times the miner will retry the command

\--address \<ETH address> - this ETH address is where you will receive future XN airdrop

\-f \<number> - priority fee setting

```
node client/miner.js mine --runs 1000 --address <ETH address> -f 100
```

<figure><img src="../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

You can check the mined SolXen balance here: [https://explorer.solana.com/?cluster=devnet](https://explorer.solana.com/?cluster=devnet)



<figure><img src="../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

Just search for your address and then tap on a transaction to review it.

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

### Update Miner

Since the miner is still being developed, there will be constant updates that will be released.\
Run the following commands to update the miner. Then run the miner again to continue.

```
git pull
```



Join SoLXEN Telegram: [https://t.me/+rrWU85yki-k3MzRj](https://t.me/+rrWU85yki-k3MzRj)
