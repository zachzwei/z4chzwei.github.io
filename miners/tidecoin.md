---
description: This is a quick guide on how to mine Tidecoin with your CPU.
---

# Tidecoin

## Disclaimer

Mining can cause hardware issues to your device. I am not responsible for any damage this can cause to you or to your machine. Proceed at your own risk. This guide is intended for educational purposes only. I am using a rented GPU/CPU miner via Vast in order to mine Tidecoin. I am not mining on my own computer. The guide is purely based on a Linux CLI (Command Line Interface), so most of the commands to run the miner will be done manually.

## Requirements

* A dedicated computer. You can rent one via Vast by using this link: [Vast AI.](https://cloud.vast.ai/?ref\_id=94252\&template\_id=3ef6c152e7b056ad868c0f2a69cb4f6f)
* A Tidecoin wallet. I suggest using the core wallet here: [Tidecoin Wallet.](https://github.com/tidecoin/tidecoin/releases/)&#x20;
* (Optional) [Tidecoin Web Wallet](https://tdc.cash/). If you do not want to download core wallet.

### Download Miner

On your terminal, create a directory. Then go to the created directory. Copy and run the commands:

```
mkdir tidecoin
cd tidecoin
```

Next, download the miner for Linux OS. Use this command:

```
wget https://github.com/rplant8/cpuminer-opt-rplant/releases/download/5.0.41/cpuminer-opt-linux-5.0.41a.tar.gz
```

This will download the CPU miner files to the directory created.&#x20;

<figure><img src="../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

### Extract Miner

Run the following command to extract the miner on the directory.

```
tar -xf cpuminer-opt-linux-5.0.41a.tar.gz
```

<figure><img src="../.gitbook/assets/image (1) (1).png" alt=""><figcaption></figcaption></figure>

### Create Miner Profile

Go to [https://pool.rplant.xyz/](https://pool.rplant.xyz/) and then on the left navigation bar click on Tidecoin. Next click on Connect. You will see a screen like this:

<figure><img src="../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

Fill out the following details as shown on the screenshot:

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

Remember to put your own address and worker name. The nearest stratum will depend on your location. As you can see I have chosen Linux/MacOS as my OS.

Next, copy the miner script that was created by the template and then go back to your Terminal.

### Create the Miner Script

On your terminal, create a script file which will continously run on your machine. Run the command:

```
nano tide_miner.sh
```

If you do not have `nano` installed, just run the command:

```
apt install nano
```

Paste the miner script to the created file and save it.

<figure><img src="../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

Set the permissions of the miner script.

```
chmod +x tide_miner.sh
```

### Run the Miner

You can now run the miner script on your machine. Make some final checks and ensure the configuration is correct.

```
./tide_miner.sh
```

This command will run your miner and will start hashing Tidecoin blocks.

### Monitor your Miner

To check the activity of your miner. Go back to [https://pool.rplant.xyz/](https://pool.rplant.xyz/) and then click on the My Miner tab. Paste your address and then click on Set.

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

You should now see your workers that are mining Tidecoin.

<figure><img src="../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

### Miner Payments

Mining rewards for   [https://pool.rplant.xyz/](https://pool.rplant.xyz/)  is specified on the Tidecoin page.&#x20;

<figure><img src="../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

You can also see the current progress of your rewards on the same screen.

<figure><img src="../.gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

Note: The miner is also available for MacOS and Windows. If you are using Windows, you can use the same steps above by using Powershell.

Once you reach the minimum payout of 5 $TDC. It will be sent to the address you have setup on the miner.

<figure><img src="../.gitbook/assets/image (55).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (56).png" alt=""><figcaption></figcaption></figure>

I would highly recommend using the core wallet to keep your Tidecoin secure.&#x20;

Not your keys, not your crypto.

<figure><img src="../.gitbook/assets/image (57).png" alt=""><figcaption></figcaption></figure>

### Closing

This coin was created by [YarSawyer](https://github.com/yarsawyer/tidecoin). Please show support for his work by following him on his socials.&#x20;

More details can be found here: [https://tidecoin.co/](https://tidecoin.co/)

If you just want to go ahead and buy Tidecoin, you can go to [Xeggex](https://xeggex.com/?ref=66e05ecdf6dc403d67b9a50e).\
Not financial advise.



Shameless plug...

If you do not want to mine $SHA, you can get it from exchanges.\
Here is my referral link for NonKYC: [https://nonkyc.io?ref=658045d205279ea14f3a7169](https://nonkyc.io/?ref=658045d205279ea14f3a7169)

Tidecoin is now on CoinGecko: [https://www.coingecko.com/en/coins/tidecoin](https://www.coingecko.com/en/coins/tidecoin)\
\
Follow my journey mining Tidecoin on X.\
[https://x.com/ZachZwei/status/1833521016372600953](https://x.com/ZachZwei/status/1833521016372600953)
