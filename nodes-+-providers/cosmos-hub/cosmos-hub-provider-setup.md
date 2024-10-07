# Cosmos Hub Provider Setup

Setting up your Cosmos Hub Provider will be similar to a Lava Provider.\
Follow the steps here for setting up your domain name:\
\
[https://node.z4ch.xyz/nodes-+-providers/lava/lava-node-setup/lava-provider-tls#setup-domain](https://node.z4ch.xyz/nodes-+-providers/lava/lava-node-setup/lava-provider-tls#setup-domain)

### Create the Provider file

After that, use the command below to generate the `.yml` file for Cosmos.

```
RPC=$(cat $HOME/.lava/config/config.toml | sed -n '/TCP or UNIX socket address for the RPC server to listen on/{n;p;}' | sed 's/.*://; s/".*//')
GRPC=$(cat $HOME/.lava/config/app.toml | sed -n '/Address defines the gRPC server address to bind to/{n;p;}' | sed 's/.*://; s/".*//')
API=$(cat $HOME/.lava/config/app.toml | sed -n '/Address defines the API server to listen on./{n;p;}' | sed 's/.*://; s/".*//')

echo "RPC:"$RPC "GRPC:"$GRPC "API:"$API

mkdir $HOME/config
sudo tee << EOF >/dev/null $HOME/config/atom.yml
endpoints:
  - api-interface: tendermintrpc
    chain-id: COSMOSHUB
    network-address:
      address: 0.0.0.0:26658
      disable-tls: true
    node-urls:
      - url: ws://127.0.0.1:$RPC/websocket
      - url: http://127.0.0.1:$RPC
  - api-interface: grpc
    chain-id: COSMOSHUB
    network-address:
      address: 0.0.0.0:26658
      disable-tls: true
    node-urls:
      url: 127.0.0.1:$GRPC
  - api-interface: rest
    chain-id: COSMOSHUB
    network-address:
      address: 0.0.0.0:26658
      disable-tls: true
    node-urls:
      url: http://127.0.0.1:$API
EOF
```

### Start the Provider

To start the Cosmos provider process, run the following command. \
Change the --geolocation value depending on where you server is located.\
Change the --from value depending on the name of your wallet

```
lavap rpcprovider atom.yml --reward-server-storage /.lava/rewardserver --geolocation 2 --from z4ch --chain-id lava-mainnet-1 --keyring-backend file --log_level debug
```

### Test the Provider Process!

Change the --from value depending on the name of your wallet.\
Change the --endpoints value depending on the domain you have setup

```
lavap test rpcprovider --from z4ch --endpoints "atom.z4ch.xyz:443,COSMOSHUB"
```

### Stake the Provider on Chain <a href="#stake-the-provider-on-chain" id="stake-the-provider-on-chain"></a>

Use a variation of the following command to stake on chain; the minimum stake is :

`15000000000ulava or 15,000 LAVA`

```
MONIKER="Provider Name"
DOMAIN="Provider Domain URL"
PORT=443
echo $MONIKER $DOMAIN $PORT
lavap tx pairing stake-provider COSMOSHUB "15000000000ulava" "$DOMAIN:$PORT,[2]" [2] [validator] --from [wallet_name] --provider-moniker "$MONIKER"  --delegate-limit "1000000000000ulava" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```

Example:

`lavap tx pairing stake-provider COSMOSHUB "15000000000ulava" "atom.z4ch.xyz:443,2" 2 lava@valoper1amkaaut9fs395v3vpuymp6zmggva32mkkvr7rq --from z4ch2 --provider-moniker "zwei node" --delegate-limit "1000000000000ulava" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y`

Some notes:

* `[validator]` you need to indicate a validator address, choose here: [https://lava.explorers.guru/validators](https://lava.explorers.guru/validators)
* `[2]` replace this with the corresponding geolocation of your server
* `--from` should be followed by the key name of your funded account that you will use to stake your provider
* `--provider-moniker` will be the name of your provider

**Congratulations, your Cosmos Provider is now up and running.**
