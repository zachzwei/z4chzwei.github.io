
# Build & Install Lava Binaries

## 🔍 Overview

Lava has three binaries which fulfill different functions:

- `lavad` - consensus mechanisms, node running, genesis files, key creation / management

- `lavap` - protocol services, rpcconsumer, rpcprovider, badge server

- [`lavavisor`](/lavavisor) - automated rpcprovider & rpcconsumer initialization and updating / synchronization of `lavap`


## 📋 Prerequisites

### Operating System 💾


Lava is designed to run on ***nix style operating systems**. While running in other setups is possible, it is generally discouraged as it may produce unexpected behavior.

### Go 📇

Lava requires `go` version `1.20.3` or greater. Run `go version` to confirm your version.

Get the [latest release](https://go.dev/doc/install)!

### Packages 📦

The following packages are known dependencies of the install process:

`make` `gcc` `jq` `unzip` `coreutils` `git`

<br/>
<hr/>

## 🗄️ Installation Options 


### Install all Binaries 🛠️  **(Recommended)**

Enter the following commands:

```bash
git clone https://github.com/lavanet/lava.git
cd lava
make install-all
```

✅ Run `lavad version && lavap version` to ensure you've gotten the [latest releases](https://github.com/lavanet/lava/releases)!

<br />

Next Step: [Setup Node](https://github.com/zachzwei/lava_docs/blob/main/docs/lava-blockchain/join-testnet-manual-cosmovisor.md)

[Back to Main](https://github.com/zachzwei/lava_docs)
