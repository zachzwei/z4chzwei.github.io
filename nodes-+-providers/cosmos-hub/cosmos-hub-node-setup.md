---
description: >-
  Follow this guide to run your own Cosmos Hub node and use it for your Lava
  Provider.
---

# Cosmos Hub

This is not financial advise. All information provided here are sourced from the following sites:\
[https://services.kjnodes.com/mainnet/cosmoshub/](https://services.kjnodes.com/mainnet/cosmoshub/)\
[https://nodestake.org/cosmos](https://nodestake.org/cosmos)\
[https://docs.cosmos.network/v0.50/user/run-node/run-production](https://docs.cosmos.network/v0.50/user/run-node/run-production)\
[https://docs.lavanet.xyz/cosmoshub-node](https://docs.lavanet.xyz/cosmoshub-node)

Hardware requirements:\
RAM: 32 GB RAM\
Storage: 500 GB - 2 TB NVME SSD\
OS: Linux 22.04

### Firewall Settings

Run the following commands:

```
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22

#Allowed Ports
sudo ufw allow 26656/tcp
sudo ufw allow 26657/tcp
sudo ufw allow 26660/tcp
sudo ufw allow 9090/tcp
sudo ufw allow 1317/tcp

sudo ufw enable

```

These are the default ports that Cosmos Hub uses. You can change it depending on your machine.

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
curl -Ls https://go.dev/dl/go1.22.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```

### Download and build binaries <a href="#download-and-build-binaries" id="download-and-build-binaries"></a>

```
# Clone project repository
cd $HOME
rm -rf gaia
git clone https://github.com/cosmos/gaia.git
cd gaia
git checkout v20.0.0

# Build binaries
make build

# Prepare binaries for Cosmovisor
mkdir -p $HOME/.gaia/cosmovisor/genesis/bin
mv build/gaiad $HOME/.gaia/cosmovisor/genesis/bin/
rm -rf build

# Create application symlinks
sudo ln -s $HOME/.gaia/cosmovisor/genesis $HOME/.gaia/cosmovisor/current -f
sudo ln -s $HOME/.gaia/cosmovisor/current/bin/gaiad /usr/local/bin/gaiad -f
```

#### Install Cosmovisor and create a service <a href="#install-cosmovisor-and-create-a-service" id="install-cosmovisor-and-create-a-service"></a>

```
# Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0

# Create service
sudo tee /etc/systemd/system/cosmoshub.service > /dev/null << EOF
[Unit]
Description=cosmoshub node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.gaia"
Environment="DAEMON_NAME=gaiad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.gaia/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable cosmoshub.service
```

### Set node configuration <a href="#set-node-configuration" id="set-node-configuration"></a>

```
# Set node configuration
gaiad config set client chain-id cosmoshub-4
gaiad config set client keyring-backend file
gaiad config set client node tcp://localhost:13457
```

#### Initialize the node <a href="#initialize-the-node" id="initialize-the-node"></a>

```
# Initialize the node
gaiad init $MONIKER --chain-id cosmoshub-4

# Download genesis and addrbook
curl -Ls https://snapshots.kjnodes.com/cosmoshub/genesis.json > $HOME/.gaia/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/cosmoshub/addrbook.json > $HOME/.gaia/config/addrbook.json

# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"400f3d9e30b69e78a7fb891f60d76fa3c73f0ecc@cosmoshub.rpc.kjnodes.com:13459\"|" $HOME/.gaia/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.005uatom\"|" $HOME/.gaia/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.gaia/config/app.toml

# Set custom ports
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:13458\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:13457\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:13460\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:13456\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":13466\"%" $HOME/.gaia/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:13417\"%; s%^address = \":8080\"%address = \":13480\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:13490\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:13491\"%; s%:8545%:13445%; s%:8546%:13446%; s%:6065%:13465%" $HOME/.gaia/config/app.toml
```

### Download latest chain snapshot <a href="#download-latest-chain-snapshot" id="download-latest-chain-snapshot"></a>

```
curl -L https://snapshots.kjnodes.com/cosmoshub/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.gaia
[[ -f $HOME/.gaia/data/upgrade-info.json ]] && cp $HOME/.gaia/data/upgrade-info.json $HOME/.gaia/cosmovisor/genesis/upgrade-info.json
```

### Start service and check the logs <a href="#start-service-and-check-the-logs" id="start-service-and-check-the-logs"></a>

```
sudo systemctl start cosmoshub.service && sudo journalctl -u cosmoshub.service -f --no-hostname -o cat
```

#### (Optional)

Alternate Snapshot from NodeStake. By doing the following steps, this will clear any snapshot you have download. Backup your /data folder in case you need it. Make sure to set the correct pruning settings for this snapshot before running your node.

Stop your Node. Run the following commands:

```
cp $HOME/.gaia/data/priv_validator_state.json $HOME/.gaia/priv_validator_state.json.backup
rm -rf $HOME/.gaia/data
rm -rf $HOME/.gaia/wasm
gaiad tendermint unsafe-reset-all --home ~/.gaia/ --keep-addr-book
```

```
SNAP_NAME=$(curl -s https://ss.cosmos.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss.cosmos.nodestake.org/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.gaia
mv $HOME/.gaia/priv_validator_state.json.backup $HOME/.gaia/data/priv_validator_state.json
```

#### Some Useful commands

Run the following to check connected peers:

```
sudo netstat -anp | grep ESTABLISHED | grep gaiad | grep -v \"127.0.0.1\
```

Check sync status:

```
gaiad status 2>&1 | jq .sync_info
```
