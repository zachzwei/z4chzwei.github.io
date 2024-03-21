# Axelar Provider Setup

The steps for creating a provider will be similar to the [Lava Provider Setup](../../lava/lava-node-setup/lava-provider-tls.md).

You might need to create a new TLS Certificate for this new site.

Make sure to set specific parameters for AXELAR spec:

`axelar_server` file

```
server {
    listen 443 ssl http2;
    server_name axelar.your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    error_log /var/log/nginx/debug.log debug;

    location / {
        proxy_pass http://127.0.0.1:2225;
        grpc_pass 127.0.0.1:2225;
    }
}
```

❗The internal comms port `2225` can be changed to any open port on your network.

`axelar-provider.yml` file

```
endpoints:
    - api-interface: tendermintrpc
      chain-id: AXELAR
      network-address:
        address: 127.0.0.1:2225
        disable-tls: true
      node-urls:
        - url: ws://127.0.0.1:17357/websocket
        - url: http://127.0.0.1:17357
    - api-interface: grpc
      chain-id: AXELAR
      network-address:
        address: 127.0.0.1:2225
        disable-tls: true
      node-urls:
        url: grpc.axelar.lava.build:443
    - api-interface: rest
      chain-id: AXELAR
      network-address:
        address: 127.0.0.1:2225
        disable-tls: true
      node-urls:
        url: https://rest.axelar.lava.build
```

* Note:

The urls for `grpc` and `rest` are [provided by Lava](https://docs.lavanet.xyz/public-rpc). If you are running your own Lava node then you can find the following information on the `config.toml` and `app.toml` files located at `./axelar/config` folder.

And the commands will now be pointing to your `axelar.your-domain`

Start the `axelar-provider`

```
lavap rpcprovider axelar-provider.yml --from your_key_name_here --geolocation 1 --chain-id lava-testnet-2 --log_level debug
```

Test the provider

```
lavap test rpcprovider --from your_key_name_here --endpoints "axelar.your-site:443,AXELAR"
```

Stake the Provider

```
lavap tx pairing stake-provider AXELAR "50000000000ulava" "axelar.your-site:443,1" 1 [validator_address] --from your_key_name_here --provider-moniker your-provider-moniker-1 --gas-adjustment "1.5" --gas "auto" --gas-prices "0.0001ulava" --chain-id lava-testnet-2 --delegate-limit 0ulava
```

Final test!

```
lavap test rpcprovider --from your_key_name_here --endpoints "axelar.your-site:443,AXELAR"
```

Congratulations, you are now a Axelar RPC Provider!

