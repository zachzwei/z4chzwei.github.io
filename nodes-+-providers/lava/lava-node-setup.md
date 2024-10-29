---
description: >-
  Follow this guide to run your own LavaNet node and use it for your Lava
  Provider.
---

# Lava Node Setup

This is not financial advise. All information provided here are sourced from the following sites:\
[https://services.kjnodes.com/mainnet/lava/installation/](https://services.kjnodes.com/mainnet/lava/installation/)\
[https://services.mellifera.network/Mainnet/lava-network/snapshot\_and\_data](https://services.mellifera.network/Mainnet/lava-network/snapshot\_and\_data)\


Hardware requirements:\
RAM: 64 GB RAM\
Storage: 2 TB NVME SSD\
OS: Linux 22.04\
Rent a server here (optional): [https://www.interserver.net/r/950716](https://www.interserver.net/r/950716)

### Set Node name

Change it to anything you like.

```
MONIKER="my_node"
```

### Install dependencies

```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```

#### Install GO

This will install Go version `1.22.8`

```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.22.8.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

go version
```

### Download and build binaries <a href="#download-and-build-binaries" id="download-and-build-binaries"></a>

```
# Clone project repository
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout v3.1.0

# Build binaries
export LAVA_BINARY=lavad
make build

# Prepare binaries for Cosmovisor
mkdir -p $HOME/.lava/cosmovisor/genesis/bin
mv build/lavad $HOME/.lava/cosmovisor/genesis/bin/
rm -rf build

# Create application symlinks
sudo ln -s $HOME/.lava/cosmovisor/genesis $HOME/.lava/cosmovisor/current -f
sudo ln -s $HOME/.lava/cosmovisor/current/bin/lavad /usr/local/bin/lavad -f
```

### Install Cosmovisor and create a service <a href="#install-cosmovisor-and-create-a-service" id="install-cosmovisor-and-create-a-service"></a>

```
# Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0

# Create service
sudo tee /etc/systemd/system/lava.service > /dev/null << EOF
[Unit]
Description=lava node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.lava"
Environment="DAEMON_NAME=lavad"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable lava.service
```

### Initialize the node <a href="#initialize-the-node" id="initialize-the-node"></a>

```
# Set node configuration
lavad config chain-id lava-mainnet-1
lavad config keyring-backend file
lavad config node tcp://localhost:14457

# Initialize the node
lavad init $MONIKER --chain-id lava-mainnet-1

# Download genesis and addrbook
curl -Ls https://snapshots.kjnodes.com/lava/genesis.json > $HOME/.lava/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/lava/addrbook.json > $HOME/.lava/config/addrbook.json

# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"400f3d9e30b69e78a7fb891f60d76fa3c73f0ecc@lava.rpc.kjnodes.com:14459\"|" $HOME/.lava/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.000000001ulava\"|" $HOME/.lava/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.lava/config/app.toml

# Set custom ports
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:14458\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:14457\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:14460\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:14456\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":14466\"%" $HOME/.lava/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:14417\"%; s%^address = \":8080\"%address = \":14480\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:14490\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:14491\"%; s%:8545%:14445%; s%:8546%:14446%; s%:6065%:14465%" $HOME/.lava/config/app.toml
```

### Update chain-specific configuration <a href="#update-chain-specific-configuration" id="update-chain-specific-configuration"></a>

```
sed -i \
  -e 's/timeout_commit = ".*"/timeout_commit = "30s"/g' \
  -e 's/timeout_propose = ".*"/timeout_propose = "1s"/g' \
  -e 's/timeout_precommit = ".*"/timeout_precommit = "1s"/g' \
  -e 's/timeout_precommit_delta = ".*"/timeout_precommit_delta = "500ms"/g' \
  -e 's/timeout_prevote = ".*"/timeout_prevote = "1s"/g' \
  -e 's/timeout_prevote_delta = ".*"/timeout_prevote_delta = "500ms"/g' \
  -e 's/timeout_propose_delta = ".*"/timeout_propose_delta = "500ms"/g' \
  -e 's/skip_timeout_commit = ".*"/skip_timeout_commit = false/g' \
  $HOME/.lava/config/config.toml
```

### Set Ports <a href="#download-latest-chain-snapshot" id="download-latest-chain-snapshot"></a>

This is a more simplified command to manually set the Ports of your LavaNet node. You can manually change it depending on your needs. Make sure there are no conflicts as this might cause the node to not run.

```
CUSTOM_PORT=144

sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.evmosd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}91\"%; s%^address = \"127.0.0.1:8545\"%address = \"0.0.0.0:${CUSTOM_PORT}45\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"0.0.0.0:${CUSTOM_PORT}46\"%" $HOME/.evmosd/config/app.toml
```

### Download latest chain snapshot <a href="#download-latest-chain-snapshot" id="download-latest-chain-snapshot"></a>

```
curl -L https://snapshots.kjnodes.com/lava/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
[[ -f $HOME/.lava/data/upgrade-info.json ]] && cp $HOME/.lava/data/upgrade-info.json $HOME/.lava/cosmovisor/genesis/upgrade-info.json
```



Make sure that the port numbers you will assign is not in use.

Use this command to check.&#x20;

```
netstat -na | grep [port-number]
```

Replace `port-number` depending on what port you are trying to check.

* Tendermint RPC

Navigate to `/.lava/config` and open `config.toml` file. Take note of the URL and Port.

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/62c6eebf-2d1d-47dd-8445-fb0864868903)

* Rest (API)

Navigate to `/.lava/config` and open `app.toml` file. Take note of the URL and Port. Make sure it is set to `enable = true`.

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/f774a2dc-dabc-45b5-a27f-ff41773aa2f1)

* gRPC

Navigate to `/.lava/config` and open `app.toml` file. Take note of the URL and Port. Make sure both gRPC and gRPC-web is set to `enable = true`.

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/66ec023a-67fc-4fe4-a1b0-5bb9aef426ea)

### Setup Firewall <a href="#start-service-and-check-the-logs" id="start-service-and-check-the-logs"></a>

These are just recommended port settings, which I am currently using. \
Change it depending on your own server settings.

```
sudo ufw default deny incoming
sudo ufw default allow outgoing

#ssh port
sudo ufw allow 22

#webmin port
sudo ufw allow 10000

#Allowed Ports
sudo ufw allow 14456/tcp
sudo ufw allow 14457/tcp
sudo ufw allow 14460/tcp
sudo ufw allow 14490/tcp
sudo ufw allow 14417/tcp
sudo ufw allow 26666/tcp
sudo ufw allow 26667/tcp
sudo ufw allow 26670/tcp
sudo ufw allow 2224
sudo ufw allow 443
sudo ufw allow 80

sudo ufw enable
```

### Start service and check the logs <a href="#start-service-and-check-the-logs" id="start-service-and-check-the-logs"></a>

```
sudo systemctl start lava.service && sudo journalctl -u lava.service -f --no-hostname -o cat
```

#### Check sync status

Run the following command:

```
lavad status 2>&1 | jq .SyncInfo
```

&#x20;If you get a result `false` that means node is fully synced.

<figure><img src="../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

Check connected peers:

```
sudo netstat -anp | grep ESTABLISHED | grep lavad | grep -v \"127.0.0.1\
```

### Archive Snapshot

If you want to run a full archive node, you can use this snapshot. The following commands will delete the existing /data folder. Make sure you create a backup in case you need it. Set the proper pruning settings to `nothing` before running the node.

```
sudo systemctl stop lava.service
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
rm -rf $HOME/.lava/data
curl -L https://storage.mellifera.network/lava_mainnet/archive_1463986.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
```

Start the node and let it sync

```
sudo systemctl start lava.service && sudo journalctl -u lava.service -f --no-hostname -o cat
```
