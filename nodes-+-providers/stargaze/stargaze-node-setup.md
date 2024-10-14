---
description: >-
  Follow this guide to run your own Stargaze node and use it for your Lava
  Provider.
---

# Stargaze Node Setup

This is not financial advise. All information provided here are sourced from the following sites:\
[https://www.polkachu.com/installation/stargaze](https://www.polkachu.com/installation/stargaze)\
[https://www.polkachu.com/tendermint\_snapshots/stargaze](https://www.polkachu.com/tendermint\_snapshots/stargaze)

RAM: 64 GB RAM\
Storage: 2 TB NVME SSD\
OS: Linux 22.04\
Rent a server here (optional): [https://www.interserver.net/r/950716](https://www.interserver.net/r/950716)

### Firewall Settings

Note:\
For reference, this is what I use for my servers:

```
sudo ufw default deny incoming
sudo ufw default allow outgoing

#ssh port
sudo ufw allow 22

#webmin port
sudo ufw allow 10000

#Allowed Ports
sudo ufw allow 16456/tcp
sudo ufw allow 16457/tcp
sudo ufw allow 16460/tcp
sudo ufw allow 16490/tcp
sudo ufw allow 16417/tcp
sudo ufw allow 26676/tcp
sudo ufw allow 26677/tcp
sudo ufw allow 26680/tcp
sudo ufw allow 2226
sudo ufw allow 443
sudo ufw allow 80

sudo ufw enable
```

### Set Node name

Change it to anything you like.

```
MONIKER="my_node"
```

### Install dependencies <a href="#install-dependencies" id="install-dependencies"></a>

#### **Update system and install build tools**

```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```

#### **Install Go**

```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.22.8.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

go version
```

### Download and build binaries <a href="#download-and-build-binaries" id="download-and-build-binaries"></a>

```
git clone https://github.com/public-awesome/stargaze stargaze
cd stargaze
git checkout v14.0.0
make install
```

#### Install Cosmovisor and create a service <a href="#install-cosmovisor-and-create-a-service" id="install-cosmovisor-and-create-a-service"></a>

```
# Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0

# Create service
sudo tee /etc/systemd/system/stargaze.service > /dev/null << EOF
[Unit]
Description="stargaze node"
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=starsd"
Environment="DAEMON_HOME=$HOME/.starsd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable stargaze.service
```

Configure Cosmovisor

```
# Create Cosmovisor Folders
mkdir -p ~/.starsd/cosmovisor/genesis/bin
mkdir -p ~/.starsd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/starsd ~/.starsd/cosmovisor/genesis/bin
```

### Set node configuration <a href="#set-node-configuration" id="set-node-configuration"></a>

Initialize node

```
starsd init $MONIKER --chain-id stargaze-1
```

Download Genesis file

```
wget -O genesis.json https://snapshots.polkachu.com/genesis/stargaze/genesis.json --inet4-only
mv genesis.json ~/.starsd/config
```

Configure Seed

```
sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:13756"/' ~/.starsd/config/config.toml
```

### Set Ports <a href="#download-latest-chain-snapshot" id="download-latest-chain-snapshot"></a>

This is a more simplified command to manually set the Ports of your LavaNet node. You can manually change it depending on your needs. Make sure there are no conflicts as this might cause the node to not run.

```
CUSTOM_PORT=164

sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.evmosd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}91\"%; s%^address = \"127.0.0.1:8545\"%address = \"0.0.0.0:${CUSTOM_PORT}45\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"0.0.0.0:${CUSTOM_PORT}46\"%" $HOME/.evmosd/config/app.toml
```

### Download Snapshot

Get Snapshot. Wait for download to finish.

```
wget -O stargaze_15817491.tar.lz4 https://snapshots.polkachu.com/snapshots/stargaze/stargaze_15817491.tar.lz4 --inet4-only
```

Prepare for extraction

```
# Back up priv_validator_state.json if needed
cp ~/.starsd/data/priv_validator_state.json  ~/.starsd/priv_validator_state.json

# Reset node state
starsd tendermint unsafe-reset-all --home $HOME/.starsd --keep-addr-book

rm -r ~/.starsd/wasm
```

Extract Snapshot

```
lz4 -c -d stargaze_15817491.tar.lz4  | tar -x -C $HOME/.starsd
```

Restore backup

```
# Replace with the backed-up priv_validator_state.json
cp ~/.starsd/priv_validator_state.json  ~/.starsd/data/priv_validator_state.json
```

Make sure to set your Pruning settings properly before launching node.

<pre><code><strong>Set the following on app.toml file
</strong>
<strong># Prune Type
</strong>pruning = "custom"

# Prune Strategy
pruning-keep-recent = "100"
pruning-keep-every = "0"
pruning-interval = "10"

Set the following on config.toml file

indexer = "null"

</code></pre>

### Start service and check the logs <a href="#start-service-and-check-the-logs" id="start-service-and-check-the-logs"></a>

```
sudo service stargaze start && sudo journalctl -fu stargaze
```

#### Some Useful commands

Run the following to check connected peers:

```
sudo netstat -anp | grep ESTABLISHED | grep starsd | grep -v \"127.0.0.1
```

Check sync status:

```
curl -s http://127.0.0.1:16457/status | jq .result.sync_info
```

#### Alias commands

I use the following to replace the long commands above. It might differ depending on your configuration.

```
# stars commands
echo "alias starspeers='sudo netstat -anp | grep ESTABLISHED | grep starsd | grep -v \"127.0.0.1"'" >> ~/.bashrc
echo "alias starssync='curl -s http://127.0.0.1:16457/status | jq .result.sync_info'" >> ~/.bashrc
echo "alias starslogs='sudo journalctl -fu stargaze'" >> ~/.bashrc
echo "alias starsstart='sudo service stargaze start'" >> ~/.bashrc
echo "alias starsstop='sudo service stargaze stop'" >> ~/.bashrc
source ~/.bashrc
```

#### Congratulations. You are now running a Stargaze Node.
