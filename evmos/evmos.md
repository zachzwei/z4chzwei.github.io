Sources: 

[https://polkachu.com/installation/evmos](https://polkachu.com/installation/evmos)

[https://stakevillage.net/en/evmos-mainnet/index.php](https://stakevillage.net/en/evmos-mainnet/index.php)

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
git clone https://github.com/tharsis/evmos evmos
cd evmos
git checkout v16.0.3
make install
```

### Configure Cosmovisor Folder
```
mkdir -p ~/.evmosd/cosmovisor/genesis/bin
mkdir -p ~/.evmosd/cosmovisor/upgrades
cp ~/go/bin/evmosd ~/.evmosd/cosmovisor/genesis/bin
```

### Сreate a service

Create a `evmos.service` file in the `/etc/systemd/system` folder with the following code snippet. 

```
[Unit]
Description="evmos node"
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/evmosd start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=evmosd"
Environment="DAEMON_HOME=/root/.evmosd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```
### Enable service

```
sudo systemctl daemon-reload
sudo systemctl enable evmos.service
```

### Initialize the node

```
evmosd init $MONIKER --chain-id evmos_9001-2
```

### Set node configuration

```
wget -O genesis.json https://snapshots.polkachu.com/genesis/evmos/genesis.json --inet4-only
mv genesis.json ~/.evmosd/config
```

### Add seeds and addressbook

```
sed -i 's/seeds = ""/seeds = "a56f27699b7e47ce79335509c0863bcfe6ae1347@rpc.evmos.nodestake.top:666"/' ~/.evmosd/config/config.toml
```
```
wget -O addrbook.json https://snapshots.polkachu.com/addrbook/evmos/addrbook.json --inet4-only
mv addrbook.json ~/.evmosd/config
```

### Set minimum gas price

```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"400000000000aevmos\"|" $HOME/.evmosd/config/app.toml
```

### Set prunning

```
pruning="custom"
pruning_keep_recent="50000"
pruning_keep_every="0"
pruning_interval="19"
```
```
sed -i "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.evmosd/config/app.toml
sed -i "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.evmosd/config/app.toml
sed -i "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.evmosd/config/app.toml
sed -i "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.evmosd/config/app.toml
```

### Set custom ports
Note: 

`You can change value CUSTOM_PORT=169 To any other ports`

```
CUSTOM_PORT=169
```

```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.evmosd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}91\"%; s%^address = \"127.0.0.1:8545\"%address = \"0.0.0.0:${CUSTOM_PORT}45\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"0.0.0.0:${CUSTOM_PORT}46\"%" $HOME/.evmosd/config/app.toml


evmosd config node tcp://localhost:${CUSTOM_PORT}57
```

### Download latest chain snapshot

```
curl -o - -L https://snapshots.polkachu.com/snapshots/evmos/evmos_19479810.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.evmosd
```

### Start service and check the logs

```
sudo service evmos start && sudo journalctl -fu evmos
```

Next: [Provider Setup](https://github.com/zachzwei/z4ch-nodes/blob/main/evmos/evmos-provider-tls.md)

[Main](https://github.com/zachzwei/z4ch-nodes)
