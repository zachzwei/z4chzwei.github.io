Source: https://stakevillage.net/en/axelar-mainnet/index.php

### Set Moniker

```
MONIKER="my-node"
```

### Install dependencies
Update system and install build tools

```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```

### Install GO

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

```
cd $HOME
rm -rf axelar-core
git clone https://github.com/axelarnetwork/axelar-core.git
cd axelar-core
git checkout v0.34.1
```
```
go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@v0.6.8-pebble
go mod tidy
go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
go mod tidy
```
```
go build -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb \
-X github.com/cosmos/cosmos-sdk/version.Version=$(git describe --tags)-pebbledb \
-X github.com/cosmos/cosmos-sdk/version.Commit=$(git log -1 --format='%H')" -o /root/go/bin/axelard ./cmd/axelard
```

### Сreate a service

```
tee /etc/systemd/system/axelard.service > /dev/null << EOF
[Unit]
Description=Axelar mainnet (PebbleDB) node service
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which axelard) start --home $HOME/.axelar
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable axelard
```

### Initialize the node

```
axelard init $MONIKER --chain-id axelar-dojo-1
```

### Set node configuration

```
curl -Ls https://snapshots.stakevillage.net/snapshots/axelar-dojo-1/genesis.json > $HOME/.axelar/config/genesis.json
curl -Ls https://snapshots.stakevillage.net/snapshots/axelar-dojo-1/addrbook.json > $HOME/.axelar/config/addrbook.json
```

### Add seeds

```
PEERS="0c9555d92aaa7cda65d3456ef1a6ac6f24e055d5@65.21.123.54:26676,69266a777c64b9533403add14fb724e2eebfd848@65.108.122.247:26656,609504b517f88f628e98d4a918ffc69e9654b451@65.108.192.147:26656,5b262497ee26cb079766e53f1a74c8e8a0f5cf7a@65.109.52.178:26656,3d67d0646cddcc203b41434aceea64ade22ba6fc@18.217.111.172:26656,6acf3b257c4d839f4f2eb077eeb9a758ba4865e7@176.103.222.161:26656,5622ce45be98fc4f54a295ded742d7c7d7551285@65.108.200.49:27856,051a6fe084df02c6a4c484139899808eea841181@13.59.129.55:26656,4f12f80da0eda26c77f2780f755cea498198f8cd@3.142.113.84:26656,3bc24a2f1da2a3b0395e3b9b82b1507ae0bbce32@157.90.91.20:13656,5581d7215b95264e600209bfed0fa28a305620dd@3.134.196.244:26656,54e0c474ba49b1e78b09c9eff1a39ca3214c65a8@185.163.64.143:26656,f7061dc29a0ac18567848c1654e01b6a7a263051@51.158.156.171:36656,25255eaac0a7b4df8caa546a48d320d9cacd1f19@3.133.230.24:26656,803d85675bc116eee836d90a916a0a5f3d0d45fc@18.139.161.51:26656,dab362b5642b752f503ad066cb30f936fc0d2310@81.196.253.241:15656,a7b306b6421a0b474a0413905ffcae780d398ecd@65.108.232.134:53656,1136202f40f158b6e11257af1a34ce5379179d05@3.141.87.0:26656,57dc509d932efd27f378079c7959bcddd1131e90@136.243.174.45:56656,590a6723091c9f7049227b043bcbe84bdbcf3b57@198.244.165.175:15656,11f64e33e76755673705fba1db25a18059a333ab@65.21.74.228:26656,e6aeadba513e216954f7330834d0af0047fccce2@3.23.243.230:26656,1bd159908c6385a5c9767711c389cbe5d2027b1d@89.149.218.182:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.axelar/config/config.toml
```

### Set minimum gas price

```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.007uaxl\"|" $HOME/.axelar/config/app.toml
```

### Set prunning

```
pruning="custom"
pruning_keep_recent="50000"
pruning_keep_every="0"
pruning_interval="19"
```
```
sed -i "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.axelar/config/app.toml
sed -i "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.axelar/config/app.toml
sed -i "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.axelar/config/app.toml
sed -i "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.axelar/config/app.toml
```

### Set Pebbledb

```
db_backend="pebbledb"
sed -i "s/^db_backend *=.*/db_backend = \"$db_backend\"/" $HOME/.axelar/config/config.toml
sed -i "s/^app-db-backend *=.*/app-db-backend = \"$db_backend\"/" $HOME/.axelar/config/app.toml
```

### Set custom ports
Note: 

`You can change value CUSTOM_PORT=173 To any other ports`

CUSTOM_PORT=173

```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.axelar/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}91\"%; s%^address = \"127.0.0.1:8545\"%address = \"0.0.0.0:${CUSTOM_PORT}45\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"0.0.0.0:${CUSTOM_PORT}46\"%" $HOME/.axelar/config/app.toml
```

### Download latest chain snapshot

```
curl -L https://snapshots.stakevillage.net/snapshots/axelar-dojo-1/axelar-dojo-1_2024-03-05.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.axelar
```

### Start service and check the logs

```
sudo systemctl start axelard && sudo journalctl -u axelard -f --no-hostname -o cat
```
