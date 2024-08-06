---
description: >-
  Setup your Xolana (X1 SVM) Validator. This is a Solana fork that Jack Levin is
  currently testing out. Running your node helps in stress testing the network
  and address potential bugs.
---

# Xolana Validator Guide

**Disclaimer**:&#x20;

Not financial advise. The only incentive you get from running a node is earning the right to ask Jack, "wen X1 mainnet?", "wen xolana?" or anything related to X1. Check the original source guide [here](https://x1.wiki/xolana/).

LFG!

### Requirement

You need to have a dedicated server that meets the basic requirements of:

* CPU: 3GHz or higher (recommended)
* RAM: 1TB or higher (recommended)

Get a server from Interserver. Use my referral link if you want: [https://www.interserver.net/r/950716](https://www.interserver.net/r/950716)

## Setup Solana CLI

Run this command on your Terminal session:

```
sh -c "$(curl -sSfL https://release.solana.com/v1.18.15/install)"
```

Make sure the apply the PATH environment once the install is done. Test by running this:

```
solana --version
```

## System Tuning (Linux only)

This will make sure that your server runs the node properly.

Run the following commands on your Terminal session:

* Optimize sysctl knobs

```
sudo bash -c "cat >/etc/sysctl.d/21-solana-validator.conf <<EOF
# Increase UDP buffer sizes
net.core.rmem_default = 134217728
net.core.rmem_max = 134217728
net.core.wmem_default = 134217728
net.core.wmem_max = 134217728

# Increase memory mapped files limit
vm.max_map_count = 1000000

# Increase number of allowed open file descriptors
fs.nr_open = 1000000
EOF"
```

```
sudo sysctl -p /etc/sysctl.d/21-solana-validator.conf
```

* Increase systemd and session file limits

Add the following line to the \[Service] section of your systemd service file.

```
LimitNOFILE=1000000
```

Or, Add the following line to the \[Manager] section of /etc/systemd/system.conf.

```
DefaultLimitNOFILE=1000000
```

Save your changes and then run these commands to reload the services.

```
sudo systemctl daemon-reload
```

```
sudo bash -c "cat >/etc/security/limits.d/90-solana-nofiles.conf <<EOF
# Increase process file descriptor count limit
* - nofile 1000000
EOF"
```

Close session, Logout and then Login. Check if the limits have taken effect.

```
ulimit -n
```

You should get a result showing `1000000`.

In case it did not work for you, you can manually set it by using this command:

```
ulimit -n 1000000
```

## Manual Xolana Build

Install Rust

```
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup component add rustfmt
```

Run update

```
rustup update
```

Update your system files

```
sudo apt-get update
sudo apt-get install libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang cmake make libprotobuf-dev protobuf-compiler
```

Clone Xolana repo

```
git clone https://github.com/jacklevin74/xolana.git
cd xolana
git checkout xolana
```

Build Xolana validator

```
cargo build --release
```

<figure><img src="../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

Once the build is done, check the version you are running

```
./target/release/solana-validator -V
```

You should see a prompt like this:

`solana-validator 1.18.15 (src:00000000; feat:4215500110, client:SolanaLabs)`

## Create Wallets

You need to create a main wallet `id.json` and 4 additional wallets for the validator namely; `identity.json`, `vote.json`, `withdrawer.json`, and `stake.json`.

Main wallet

```
solana-keygen new --no-passphrase -o id.json
```

4 additional wallets

```
solana-keygen new --no-passphrase -o identity.json
solana-keygen new --no-passphrase -o vote.json
solana-keygen new --no-passphrase -o withdrawer.json
solana-keygen new --no-passphrase -o stake.json
```

Take note of the seed phrases of your wallets. You might need them in the future.

<figure><img src="../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

### Fund Wallets

Connect CLI to Xolana Network by running this command:

```
solana config set -u http://xolana.xen.network:8899
```

Then airdrop 100 SOL to your main wallet.

```
solana airdrop 100
```

<figure><img src="../.gitbook/assets/image (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

## Run Read Only Node

It is best practice to always run your node first in read only until it is fully synced.

Using the following command, this should run your server in read only.

```
nohup solana-validator --identity identity.json --limit-ledger-size 50000000 --rpc-port 8899 --entrypoint xolana.xen.network:8001 --full-rpc-api --log - --vote-account vote.json --max-genesis-archive-unpacked-size 1073741824 --no-incremental-snapshots --require-tower --enable-rpc-transaction-history --enable-extended-tx-metadata-storage --skip-startup-ledger-verification --no-poh-speed-test &
```

This will run the node in the background. You can check logs by running this command and see if it is working:

```
tail -f nohup.out
```

To check if your node is fully synced, you can run this command:

```
solana catchup --our-localhost
```

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

## Stake SOL Tokens

Send 100 SOL to identity.json address. PUBKEY or public key is the address of your generated wallets.

```
solana transfer <IDENTITY_PUBKEY> 100 --allow-unfunded-recipient
```

Create Stake account

```
solana create-stake-account stake.json 10
```

Create Vote account

```
solana create-vote-account vote.json identity.json <WITHDRAWER_PUBKEY> --commission 10
```

Transfer SOL to Stake account

```
solana transfer <STAKE_PUBKEY> 10
```

Run Delegate Stakeke command

```
solana delegate-stake stake.json vote.json
```

Run Stake command

```
solana stake-account stake.json
```

Check your stakes on the vote.json address

```
solana stakes <VOTE_PUBKEY>
```

<figure><img src="../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

## Relaunch Validator and Final Checks

Get ID of the running validator

```
ps aux | grep solana-validator
```

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

Kill validator

```
kill <# beside the logged in profile>
example:
kill 143551
```

Run the command again to check if it is still running.&#x20;

```
ps aux | grep solana-validator
```

Run the validator using the following command:

```
nohup ./target/release/solana-validator --identity identity.json --limit-ledger-size 50000000 --rpc-port 8899 --entrypoint xolana.xen.network:8001 --full-rpc-api --log - --vote-account vote.json --max-genesis-archive-unpacked-size 1073741824 --no-incremental-snapshots --require-tower --enable-rpc-transaction-history --enable-extended-tx-metadata-storage --skip-startup-ledger-verification --rpc-pubsub-enable-block-subscription &
```

Check logs:

```
tail -f nohup.out
```

Check list of nodes and validators. Look for your identity and it should match the IP address of your server.

```
solana gossip
```

<figure><img src="../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

Finally, check validators list

```
solana validators
```

<figure><img src="../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

If your node does not have an exclamation warning, then it is running fine.

Congratulations, you have successfully ran your own Xolana Validator.

### Need Help?

Join Telegram: [https://t.me/+gBrQjWYlyZYxZTBk](https://t.me/+gBrQjWYlyZYxZTBk)\
Watch Full guide video by Xenducation: [https://youtu.be/o61ROj-H0zY?si=dTZ8gtcEDLBwRXfp](https://youtu.be/o61ROj-H0zY?si=dTZ8gtcEDLBwRXfp)
