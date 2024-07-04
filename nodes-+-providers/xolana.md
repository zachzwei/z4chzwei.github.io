---
description: >-
  Setup your Xolana (X1 SVM) Validator. This is a Solana fork that Jack Levin is
  currently testing out. Running your node helps in stress testing the network
  and address potential bugs.
---

# Xolana

**Disclaimer**:&#x20;

Not financial advise. The only incentive you get from running a node is earning the right to ask Jack, "wen X1 mainnet?", "wen xolana?" or anything related to X1. Check the original source guide [here](https://x1.wiki/xolana/).

LFG!

### Requirement

You need to have a dedicated server that meets the basic requirements of:

* CPU: 3GHz or higher (recommended)
* RAM: 1TB or higher (recommended)

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

