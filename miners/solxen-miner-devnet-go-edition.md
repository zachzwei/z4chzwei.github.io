---
description: Shaking up rusty Solana
---

# SolXEN Miner (DevNet) Go Edition

**Disclaimer!**&#x20;

Not Financial Advise. Educational purposes only.&#x20;

This is running purely on [Solana DevNet](https://explorer.solana.com/?cluster=devnet).

Tested on a 10-Core CPU server with Ubuntu 22.04.

Official site: [https://github.com/mmc-98/solxen-tx](https://github.com/mmc-98/solxen-tx)



### Install Go

```
wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

Check Go version

```
go version
```

### Download Miner

Choose the file that corresponds to the machine that you are using.\
Go here: [https://github.com/mmc-98/solxen-tx/releases](https://github.com/mmc-98/solxen-tx/releases)

As of writing the most current version is `deltaAlpha8`.

<figure><img src="../.gitbook/assets/image (1) (1).png" alt=""><figcaption></figcaption></figure>

Since I am running a bare metal Linux Server, I need to get the following file:\
[solxen-tx-deltaAlpha8-linux-amd64.tar.gz](https://github.com/mmc-98/solxen-tx/releases/download/deltaAlpha8/solxen-tx-deltaAlpha8-linux-amd64.tar.gz)

\
Run the following command to download it:

```
wget https://github.com/mmc-98/solxen-tx/releases/download/deltaAlpha8/solxen-tx-deltaAlpha8-linux-amd64.tar.gz
```

Extract the miner:

```
tar -vxzf solxen-tx-deltaAlpha8-linux-amd64.tar.gz
```

Make it executable:

```
chmod +x solxen-tx
```

### Configure Miner

```
nano solxen-tx.yaml    
```

This new version requires your Mnemonic instead of a Private Key. You can use wallets generated from Phantom. \
Make sure to change the ToAddr to your own ETH address. You can also change the Url for the RPC.\


<figure><img src="../.gitbook/assets/image (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

Save file.





### Get SOL Devnet Tokens

Go here [https://faucet.solana.com/](https://faucet.solana.com/) and Enter your SOL address.

Make sure that you are requesting **Devnet** tokens.

If you have a GitHub account, you can request more tokens.

<figure><img src="../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>



### Run SolXEN miner

```
./solxen-tx
```

<figure><img src="../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

Congratulations, you are now mining SolXEN.

You can check the transactions here: [https://explorer.solana.com/?cluster=devnet](https://explorer.solana.com/?cluster=devnet)

Just search for your address and then tap on a transaction to review it.

<figure><img src="../.gitbook/assets/image (30).png" alt=""><figcaption></figcaption></figure>

Check your SolXEN tokens by going to the Tokens tab of the explorer.

<figure><img src="../.gitbook/assets/image (31).png" alt=""><figcaption></figcaption></figure>

Join SoLXEN Telegram: [https://t.me/+rrWU85yki-k3MzRj](https://t.me/+rrWU85yki-k3MzRj)
