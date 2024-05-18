---
description: Shaking up rusty Solana
---

# SolXEN Miner (Xolana) Epsilon

**Disclaimer!**&#x20;

Not Financial Advise. Educational purposes only.&#x20;

This is running on a Solana Fork [Xolana](https://github.com/jacklevin74/xolana).

Tested on a bare metal server with Ubuntu 22.04.

Source: [https://github.com/FairCrypto/sol-xen](https://github.com/FairCrypto/sol-xen)

This miner is designed to utilize all Solana threads which was not possible on Devnet (also Mainnet) Solana.\


<figure><img src="../.gitbook/assets/image (34).png" alt=""><figcaption></figcaption></figure>

### Install Solana CLI

This will be used to generate your wallet.

Run the following command:

```
sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"
```



### Generate wallets

Run the following command:

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


### Get SOL Xolana Tokens

Switch to the Xolana Testnet by running this command.

```
solana config set -u http://69.10.34.226:8899
```

Next, run the following commands to airdrop 100 SOL to each wallet.

```
solana airdrop 100 <pubkey of id0.json>
```

Example:&#x20;

`solana airdrop 100 2KgowxogBrGqRcgXQEmqFvC3PGtCu66qERNJevYW8Ajh`

Do the same command for the other wallets, id1.json, id2.json and id2.json.

### Install Rust

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



### Install SolXen miner

Clone the SolXEN repository:

```
git clone https://github.com/FairCrypto/sol-xen.git
cd sol-xen
git checkout epsilon
```

### Configure miner

Create a `.env` file:

```
nano .env
```

Paste the following and the save file. Make sure to set the correct path for your SOL wallet

```
USER_WALLET=../.config/solana/id0.json
ANCHOR_PROVIDER_URL=http://69.10.34.226:8899
PROGRAM_ID=Dx7zjkWZbUStmhjo8BrhbprtQCcMByJgCTEC6TLgkH8n
PROGRAM_ID_MINTER=2nHCigQaERP2gUJVqeMXz1D6xrCr6RYLY8UptQUNGbHg
DEBUG=*
```

Save the file.

### Run SolXEN miner

These commands need to be run individually on each separate terminal or session (via tmux).

Use your own ETH address for every command.

\---

Notice that the id0.json file is being used here and --kind 0 is set for this miner.

```
export USER_WALLET=../.config/solana/id0.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 0 --fee 1; sleep 10; done
```

Notice that the id1.json file is being used here and --kind 1 is set for this miner.

```
export USER_WALLET=../.config/solana/id1.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 1 --fee 1; sleep 10; done
```

Notice that the id2.json file is being used here and --kind 2 is set for this miner.

```
export USER_WALLET=../.config/solana/id2.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 2 --fee 1; sleep 10; done
```

Notice that the id3.json file is being used here and --kind 3 is set for this miner.

```
export USER_WALLET=../.config/solana/id3.json # change the path if necessary

while true; do cargo run --package sol-xen-client -- --address <ETH address> --command mine --kind 3 --fee 1; sleep 10; done
```

This is how it would look like if you are using tmux to run 4 separate sessions.

<figure><img src="../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

### Mint SolXEN token

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

### Check Token Balance

Finally, to check how many tokens have been mined, you need to run these commands individually to see the token balance for each miner.

```
solana config set --keypair ~/.config/solana/id0.json

spl-token accounts
```

```
solana config set --keypair ~/.config/solana/id1.json

spl-token accounts
```

```
solana config set --keypair ~/.config/solana/id2.json

spl-token accounts
```

```
solana config set --keypair ~/.config/solana/id3.json

spl-token accounts
```

<figure><img src="../.gitbook/assets/image (37).png" alt=""><figcaption></figcaption></figure>

Check your current miner rank here: [https://solxen.io/leaderboard](https://solxen.io/leaderboard)

<figure><img src="../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>



Congratulations, you are now mining SolXEN Epsilon.\
Thanks to [xen\_artist](https://twitter.com/xen\_artist) for his [guide](https://x1.wiki/solxen/).

Join SoLXEN Telegram: [https://t.me/+rrWU85yki-k3MzRj](https://t.me/+rrWU85yki-k3MzRj)
