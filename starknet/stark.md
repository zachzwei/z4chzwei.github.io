## ⚙️ Installation

### Prerequisites

- Golang 1.20 or higher is required to build and run the project. You can find the installer on
  the official Golang [download](https://go.dev/doc/install) page.
- Docker Engine (https://docs.docker.com/engine/install/)
- [Rust](https://www.rust-lang.org/tools/install).
- A C compiler: `gcc` or `clang`.
- Lava account (https://gateway.lavanet.xyz/)
- Lava points (optional) (https://points.lavanet.xyz/register?code=3HAC1)

### Run with Docker using Lava ETH RPC

#### Note:

```
The steps below will run your node and download the snapshot from block 0. The sync will take a while to complete.
Proceed with the instructions below on how to download a snapshot first before running your node.
```
==========

To run Juno with Docker, use the following command. Make sure to create the `$HOME/juno` directory on your local machine before running the command.

```
docker run -d \
  --name juno \
  -p 6060:6060 \
  -v $HOME/juno:/var/lib/juno \
  nethermind/juno:latest \
  --http \
  --http-port 6060 \
  --http-host 0.0.0.0 \
  --db-path /var/lib/juno \
  --eth-node <YOUR-ETH-NODE>
```

Replace `<YOUR-ETH-NODE> `with your own ETH endpoint from Lava.

<img width="898" alt="image" src="https://github.com/zachzwei/juno-starknet-node/assets/35627271/df213c6b-dcc1-40e3-928b-863aafdb7075">

To view logs from the Docker container, use the following command:

```
docker logs -f juno
```

## 📸 Snapshots

Use the provided snapshots to quickly sync your Juno node with the current state of the network. 

#### Mainnet

| Version | Size | Block | Download Link |
| ------- | ---- | ----- | ------------- |
| **>=v0.9.2**  | **156 GB** | **519634** | [**juno_mainnet.tar**](https://juno-snapshots.nethermind.dev/mainnet/juno_mainnet_v0.9.3_519634.tar) |

#### Goerli

| Version | Size | Block | Download Link |
| ------- | ---- | ----- | ------------- |
| **>=v0.9.2** | **48 GB** | **931113** | [**juno_goerli.tar**](https://juno-snapshots.nethermind.dev/goerli/juno_goerli_v0.9.2_931113.tar) |

### Run Juno Using Snapshot

1. **Download Snapshot**

   Fetch the snapshot from the provided URL:

   ```bash
   wget -O juno_mainnet.tar https://juno-snapshots.nethermind.dev/mainnet/juno_mainnet_v0.9.3_519634.tar
   ```

2. **Prepare Directory**

   Ensure you have a directory at `$HOME/snapshots`. If it doesn't exist yet, create it:

   ```bash
   mkdir -p $HOME/snapshots
   ```

3. **Extract Tarball**

   Extract the contents of the `.tar` file:

   ```bash
   tar -xvf juno_mainnet.tar -C $HOME/snapshots
   ```

4. **Run Juno**

   Execute the Docker command to run Juno, ensuring that you're using the correct snapshot path `$HOME/snapshots/juno_mainnet`:

   ```bash
   docker run -d \
     --name juno \
     -p 6060:6060 \
     -v $HOME/snapshots/juno_mainnet:/var/lib/juno \
     nethermind/juno:latest \
     --http \
     --http-port 6060 \
     --http-host 0.0.0.0 \
     --db-path /var/lib/juno \
     --eth-node <YOUR-ETH-NODE>
   ```

After following these steps, Juno should be up and running on your machine, utilizing the provided snapshot.

# Setting up a Provider

The steps for creating a provider will be similar to this guide:
https://github.com/zachzwei/lava_docs/blob/main/docs/provider/provider-tls.md

Make sure to set specific parameters for STRK spec:

`strk_server` file
```
server {
    listen 443 ssl http2;
    server_name strk.z4ch.xyz;

    ssl_certificate /etc/letsencrypt/live/z4ch.xyz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/z4ch.xyz/privkey.pem;
    error_log /var/log/nginx/debug.log debug;

    location / {
        proxy_pass http://127.0.0.1:2221;
        grpc_pass 127.0.0.1:2221;
    }
}
```

`strk-provider.yml` file
```
endpoints:
    - api-interface: jsonrpc
      chain-id: STRK
      network-address:
        address: 127.0.0.1:2221
        disable-tls: true
      node-urls:
        url: http://127.0.0.1:6065
```

And the commands will now be pointing to your `strk.your-domain`

Start the `strk-provider`

```
lavap rpcprovider strk-provider.yml --from your_key_name_here --geolocation 1 --chain-id lava-testnet-2 --log_level debug
```

Test the provider
```
lavap test rpcprovider --from your_key_name_here --endpoints "strk.your-site:443,STRK"
```

Stake the Provider
```
lavap tx pairing stake-provider STRK "50000000000ulava" "strk.your-site:443,1" 1 [validator] -y --from your_key_name_here --provider-moniker your-provider-moniker-1 --gas-adjustment "1.5" --gas "auto" --gas-prices "0.0001ulava" --chain-id lava-testnet-2 --delegate-limit 0ulava
```

Final test!
```
lavap test rpcprovider --from your_key_name_here --endpoints "strk.your-site:443,STRK"
```

Congratulations, you are now a Starket RPC Provider!



In case you are getting errors with your test.

Check if port `6061` is in use/open
```
ss -na | grep :6061
```

If it is not in use, open port `6061`

```
sudo ufw allow 6061
```

