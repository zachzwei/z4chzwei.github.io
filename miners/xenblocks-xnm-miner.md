---
description: Start mining XNM using your GPU. Cloud GPU also supported.
---

# XENBlocks XNM Miner

Learn more about XENBlocks here: \
[https://www.xencrypto.io/xenblocks-merged-pow-pos-chain-launched-by-jack-levin](https://www.xencrypto.io/xenblocks-merged-pow-pos-chain-launched-by-jack-levin)

NOT Financial Advice!

### Requirements

* Linux
* Cuda capable GPU

Use my Vast link (optional) to rent a machine that can mine XNM. Click [here](https://cloud.vast.ai/?ref\_id=94252\&creator\_id=94252\&name=nvidia%2Fcuda%3A12.4.1-devel-ubuntu22.04).

## How to mine XNM

* Copy and Paste the following to a terminal session:

```
#!/bin/bash
wget https://github.com/woodysoil/XenblocksMiner/releases/download/v1.3.1/xenblocksMiner-1.3.1-linux.tar.gz
tar -vxzf xenblocksMiner-1.3.1-linux.tar.gz
chmod +x xenblocksMiner
echo -e "<YOUR-ETH-ADDRESS>\n10" | ./xenblocksMiner
```

Note:

Change \<YOUR-ETH-ADDRESS> to the destination ETH address.

n10 means that there is a dev fee of 1% sent to the creator of xenblockminer, [woodysoil](https://github.com/woodysoil/XenblocksMiner/).&#x20;

* Hit Enter to run the miner. Profit!

The miner will be downloaded and will be run with the specified settings.

<figure><img src="../.gitbook/assets/image (42).png" alt=""><figcaption></figcaption></figure>

Congratulations, you are now mining XNM.

<figure><img src="../.gitbook/assets/image (43).png" alt=""><figcaption></figcaption></figure>



## AutoRun Miner (Optional)

You can create an onstart.sh file on your root directory that will autorun the miner if your machine reboots.

Just copy the commands above and then type the following on your terminal:

```
nano onstart.sh
```

Then paste your commands. Save file. That is it.

<figure><img src="../.gitbook/assets/image (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

Join XENBlocks Telegram here: [https://t.me/+x6000bzbsHg2ZDNj](https://t.me/+x6000bzbsHg2ZDNj)
