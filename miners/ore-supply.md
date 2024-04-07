---
description: >-
  Ore is a digital currency you can mine from anywhere, at home or on your
  phone.
---

# Ore Supply

### Disclaimer!&#x20;

Not Financial Advise. Educational purposes only.&#x20;

Tested on a 20-Core CPU server with Ubuntu 22.04.

Official site: [https://ore.supply](https://ore.supply)



### Requirements

* SOL to fund miner.
* SOL RPC provider.
* Some basic CLI knowledge
* Patience

### Install RUST

Run the following command on your Terminal:&#x20;

```
curl https://sh.rustup.rs -sSf | sh
```

&#x20;Choose option 1 for the standard install.

<figure><img src="../.gitbook/assets/image.png" alt="" width="563"><figcaption></figcaption></figure>

Copy the PATH environment specified after the install.

<figure><img src="../.gitbook/assets/image (1).png" alt="" width="509"><figcaption></figcaption></figure>

### Install Solana CLI

This will be used to generate your wallet.

Run the following command:

```
sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"
```

Afterwards, copy the specified PATH and run it to finish the install.

<figure><img src="../.gitbook/assets/image (2).png" alt="" width="563"><figcaption></figcaption></figure>

#### Generate a wallet

Run the following command:

```
solana-keygen new
```

<figure><img src="../.gitbook/assets/image (3).png" alt="" width="563"><figcaption></figcaption></figure>

This will generate a new keypair and save it on the `.config` directory.&#x20;

Take note of this directory which will be used later.

Send some **SOL** to the address. The miner will use this for transaction fees.

#### (Optional) Recover a wallet

If you already have an existing wallet, you can recover that by using the following command:

```
solana-keygen recover
```

<figure><img src="../.gitbook/assets/image (4).png" alt="" width="563"><figcaption></figcaption></figure>

Double check the pubkey and confirm if that is the correct address you are restoring.

### Install ORE-CLI

Run the following command:

```
cargo install ore-cli
```

<figure><img src="../.gitbook/assets/image (5).png" alt="" width="516"><figcaption></figcaption></figure>

### Create a Solana Endpoint (RPC)

Use the following [link](https://quicknode.com/?via=z4ch) (optional) to sign up to QuickNode.&#x20;

You can create a Free RPC to test. Once all credits are used up, you can purchase a plan for additional credits.&#x20;

Take note of the HTTP Provider link.

<figure><img src="../.gitbook/assets/image (6).png" alt="" width="439"><figcaption></figcaption></figure>

### Create an ORE Miner script

In this example, I created `ore.sh`

```
nano ore.sh
```

Run "apt-get install nano" if it is not available.&#x20;

Copy and paste the following template on the file.&#x20;

```
until bash -c "ore \
    --rpc <RPC> \
    --keypair <KEYPAIR> \
    --priority-fee <FEE> \
    mine \
    --threads <CORES>"; do
    echo "Command failed,retry."
    sleep 1
done
```

Check your CPU thread count by running this command:

```
egrep '^processor' /proc/cpuinfo | sort -u | wc -l
```

<figure><img src="../.gitbook/assets/image (13).png" alt=""><figcaption></figcaption></figure>



<figure><img src="../.gitbook/assets/image (14).png" alt=""><figcaption></figcaption></figure>

Modify the values for RPC, KEYPAIR, FEE and CORES.

Save the file.

Run the following command to make the script executable:

```
chmod +x ore.sh
```

### Run ORE Miner script

Run the miner with the following command:

```
./ore.sh
```

<figure><img src="../.gitbook/assets/image (8).png" alt="" width="563"><figcaption></figcaption></figure>

Congratulations. \
You are now mining $ORE.

### Additional Commands

#### Create the ORE token account in case you are getting an account not found error.

```
spl-token create-account oreoN2tQbHXVaZsr3pf66A48miqcBXCDJozganhEJgz
```

#### Check Rewards

```
ore --keypair <KEYPAIR> rewards
```

#### Claim Rewards

```
ore --keypair <KEYPAIR> claim <AMOUNT> --rpc <RPC> --priority-fee <FEE>
```

<figure><img src="../.gitbook/assets/image (9).png" alt="" width="426"><figcaption></figcaption></figure>

### Sources

[https://ore.supply/download](https://ore.supply/download)\
[https://crates.io/crates/ore-cli](https://crates.io/crates/ore-cli)\
[https://twitter.com/HardhatChad](https://twitter.com/HardhatChad)
