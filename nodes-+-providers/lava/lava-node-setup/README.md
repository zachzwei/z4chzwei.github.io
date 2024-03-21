# Lava Node Setup

([source](https://stakevillage.net/en/lava-testnet2/index.php))

### Setup validator name

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

### Install GO

Required is version `1.20.5`

```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.20.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```

### Download and build binaries

Clone project repository

```
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout v0.35.0
```

Build binaries

```
export LAVA_BINARY=lavad
make build
```

Prepare binaries for Cosmovisor

```
mkdir -p $HOME/.lava/cosmovisor/genesis/bin
mv build/lavad $HOME/.lava/cosmovisor/genesis/bin/
rm -rf build
```

Create application symlinks

```
sudo ln -s $HOME/.lava/cosmovisor/genesis $HOME/.lava/cosmovisor/current -f
sudo ln -s $HOME/.lava/cosmovisor/current/bin/lavad /usr/local/bin/lavad -f
```

### Create a service

Download and install Cosmovisor

```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

Create service

```
sudo tee /etc/systemd/system/lavad.service > /dev/null << EOF
[Unit]
Description=Lava node service
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
```

Enable service

```
sudo systemctl daemon-reload
sudo systemctl enable lavad
```

### Initialize the node

Set node configuration

```
lavad config chain-id lava-testnet-2
lavad config keyring-backend test
lavad config node tcp://localhost:26657
```

Initialize the node

```
lavad init $MONIKER --chain-id lava-testnet-2
```

Download genesis and addrbook

```
curl -Ls http://snapshots.stakevillage.net/snapshots/lava-testnet-2/genesis.json > $HOME/.lava/config/genesis.json
```

Add seeds

```
sed -i -e "s|^seeds *=.*|seeds = \"3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@testnet2-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@testnet2-seed-node2.lavanet.xyz:26656\"|" $HOME/.lava/config/config.toml
```

Set minimum gas price

```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001ulava\"|" $HOME/.lava/config/app.toml
```

Settings

```
sed -i -e "s|^timeout_commit *=.*|timeout_commit = \"30s\"|" $HOME/.lava/config/config.toml
sed -i -e "s|^timeout_propose *=.*|timeout_propose = \"1s\"|" $HOME/.lava/config/config.toml
sed -i -e "s|^timeout_precommit *=.*|timeout_precommit = \"1s\"|" $HOME/.lava/config/config.toml

sed -i -e "s|^timeout_precommit_delta *=.*|timeout_precommit_delta = \"500ms\"|" $HOME/.lava/config/config.toml
sed -i -e "s|^timeout_prevote *=.*|timeout_prevote = \"1s\"|" $HOME/.lava/config/app.toml

sed -i -e "s|^timeout_prevote_delta *=.*|timeout_prevote_delta = \"500ms\"|" $HOME/.lava/config/config.toml
sed -i -e "s|^timeout_propose_delta *=.*|timeout_propose_delta = \"500ms\"|" $HOME/.lava/config/config.toml
sed -i -e "s|^skip_timeout_commit *=.*|skip_timeout_commit = false|" $HOME/.lava/config/config.toml
```

Set pruning

```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.lava/config/app.toml
```

### Download genesis

```
curl -Ls http://snapshots.stakevillage.net/snapshots/lava-testnet-2/genesis.json > $HOME/.lava/config/genesis.json
```

### Set custom ports

You can change value CUSTOM\_PORT=145 to any other ports

```
CUSTOM_PORT=145
```

```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.lava/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CUSTOM_PORT}91\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${CUSTOM_PORT}45\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${CUSTOM_PORT}46\"%" $HOME/.lava/config/app.toml
```

Set config with new custom port

```
lavad config node tcp://localhost:${CUSTOM_PORT}57
```

### Download latest chain snapshot

```
curl -L https://snapshots.stakevillage.net/snapshots/lava-testnet-2/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
[[ -f $HOME/.lava/data/upgrade-info.json ]] && cp $HOME/.lava/data/upgrade-info.json $HOME/.lava/cosmovisor/genesis/upgrade-info.json
```

### Verify port configurations

* Tendermint RPC

Navigate to `/.lava/config` and open `config.toml` file. Take note of the URL and Port.

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/62c6eebf-2d1d-47dd-8445-fb0864868903)

* Rest (API)

Navigate to `/.lava/config` and open `app.toml` file. Take note of the URL and Port. Make sure it is set to `enable = true`.

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/f774a2dc-dabc-45b5-a27f-ff41773aa2f1)

* gRPC

Navigate to `/.lava/config` and open `app.toml` file. Take note of the URL and Port. Make sure both gRPC and gRPC-web is set to `enable = true`.

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/66ec023a-67fc-4fe4-a1b0-5bb9aef426ea)

### Start service and check the logs

```
sudo systemctl start lavad && sudo journalctl -u lavad -f --no-hostname -o cat
```

###

Check sync status. If you get a result `false` that means node is fully synced.

```
$HOME/.lava/cosmovisor/current/bin/lavad status | jq .SyncInfo.catching_up
```
