---
description: >-
  The following steps is for those who want to create their own solo mining
  pool. Works best if you want to consolidate all your hashing power.
---

# Shaicoin Solo Pool

Once you have done the steps in setting up your Core Wallet, [https://node.z4ch.xyz/miners/shaicoin#run-core-wallet-and-sync](https://node.z4ch.xyz/miners/shaicoin#run-core-wallet-and-sync)\
You can go ahead and configure your own solo mining pool. Let's proceed.

### Configure RPC ports

Stop your core wallet by going to the `/shaicoin` folder and run the following command:

```
cd
cd shaicoin
./shaicoin-cli stop
```

<figure><img src="../../.gitbook/assets/image (75).png" alt=""><figcaption></figcaption></figure>

You can check your node to confirm it has already stopped.

<figure><img src="../../.gitbook/assets/image (76).png" alt=""><figcaption></figcaption></figure>

Next, create a `shai.conf` file on your `.shaicoin` directory. Here are the steps:

```
cd
cd .shaicoin
touch shai.conf
```

<figure><img src="../../.gitbook/assets/image (77).png" alt=""><figcaption></figcaption></figure>

Open the `shai.conf` file...

```
nano shai.conf
```

Copy and paste the following. Then save it. CTRL X, Y then Enter

```
# Enable RPC server
server=1

# Set the username and password for RPC
rpcuser=user
rpcpassword=password

# Optional: Bind to your IP address (leave localhost for local connections)
rpcbind=127.0.0.1

# RPC listening port
rpcport=8710

# Allow only connections from localhost
rpcallowip=127.0.0.1

# Maximum number of connections
maxconnections=16

# Enable logging (optional)
logtimestamps=1


```

<figure><img src="../../.gitbook/assets/image (78).png" alt=""><figcaption></figcaption></figure>

Start your node and let it sync again to the network.

```
cd
cd shaicon
cd src
./shaicoind
```

<figure><img src="../../.gitbook/assets/image (79).png" alt=""><figcaption></figcaption></figure>

### Install Solo Pool repo

Install **Node.js 23.x**:

Before you begin, ensure that `curl` is installed on your system. If `curl` is not installed, you can install it using the following command:

```
sudo apt-get install -y curl
```

1.  **Download the setup script:**

    ```
    curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
    ```
2.  **Run the setup script with sudo:**

    ```
    sudo -E bash nodesource_setup.sh
    ```
3.  **Install Node.js:**

    ```
    sudo apt-get install -y nodejs
    ```
4.  **Verify the installation:**

    ```
    node -v
    ```

<figure><img src="../../.gitbook/assets/image (81).png" alt=""><figcaption></figcaption></figure>

Copy the Shaicoin Solo Backend repo.

```
cd
git clone https://github.com/shaicoin/shaipot-solo-backend.git
cd shaipot-solo-backend
```

<figure><img src="../../.gitbook/assets/image (82).png" alt=""><figcaption></figcaption></figure>

Install Dependencies

```
npm install
```

<figure><img src="../../.gitbook/assets/image (83).png" alt=""><figcaption></figcaption></figure>

Build Native Addon

```
npm run build
```

<figure><img src="../../.gitbook/assets/image (84).png" alt=""><figcaption></figcaption></figure>

### Configure Solo pool

Open `config.json` file.

```
nano config.json
```

&#x20;and change the information based on your node settings. Then save it.

```
{
    "rpc_url": "http://your_rpc_server:port",
    "rpc_username": "user",
    "rpc_password": "password",
    "pool_shaicoin_address": "your_pool_address"
}
```

Here is an example:

<figure><img src="../../.gitbook/assets/image (85).png" alt=""><figcaption></figcaption></figure>

### Run Solo pool

Run your solo pool with this command:

```
node server.js
```

<figure><img src="../../.gitbook/assets/image (86).png" alt=""><figcaption></figcaption></figure>

### Connect miners

Using the same command for connecting to a mining pool, make sure you set the correct IP:port for the --pool settings.

```
./target/release/shaipot --address sh1xxxxxxxxxxxxxj --pool ws://161.97.130.233:3333
```

<figure><img src="../../.gitbook/assets/image (87).png" alt=""><figcaption></figcaption></figure>

Your mining pool will also indicate once a miner is connected to it. Congratulations you have successfully setup your own solo mining pool.

<figure><img src="../../.gitbook/assets/image (88).png" alt=""><figcaption></figcaption></figure>

Note:\
You can also use the same approach for creating a public mining pool.\
See instructions here:\
[https://github.com/shaicoin/shaipot-backend](https://github.com/shaicoin/shaipot-backend)

