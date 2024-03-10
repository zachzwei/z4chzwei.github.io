# Setting up a Provider

The steps for creating a provider will be similar to the [Lava Provider Setup](https://github.com/zachzwei/z4ch-nodes/blob/main/lava/lava-provider-tls.md).

You might need to create a new TLS Certificate for this new site.

Make sure to set specific parameters for EVMOS spec:

`evmos_server` file
```
server {
    listen 443 ssl http2;
    server_name evmos.your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    error_log /var/log/nginx/debug.log debug;

    location / {
        proxy_pass http://127.0.0.1:2226;
        grpc_pass 127.0.0.1:2226;
    }
}
```

❗The internal comms port `2226` can be changed to any open port on your network.

`evmos-provider.yml` file
```
endpoints:
    - api-interface: tendermintrpc
      chain-id: EVMOS
      network-address:
        address: 127.0.0.1:2226
        disable-tls: true
      node-urls:
        - url: ws://127.0.0.1:16957/websocket
        - url: http://127.0.0.1:16957
    - api-interface: grpc
      chain-id: EVMOS
      network-address:
        address: 127.0.0.1:2226
        disable-tls: true
      node-urls:
        url: grpc.evmos.lava.build:443
    - api-interface: rest
      chain-id: EVMOS
      network-address:
        address: 127.0.0.1:2226
        disable-tls: true
      node-urls:
        url: https://rest.evmos.lava.build
    - api-interface: jsonrpc
      chain-id: EVMOS
      network-address:
        address: 127.0.0.1:2226
        disable-tls: true
      node-urls:
        url: https://evmos.lava.build
```

* Note:
  
The urls for `grpc`,`rest` and `jsonrpc` are [provided by Lava](https://docs.lavanet.xyz/evmos-dev).
If you are running your own Lava node then you can find the following information on the `config.toml` and `app.toml` files located at `./evmosd/config` folder.


And the commands will now be pointing to your `evmos.your-domain`

Start the `evmos-provider`

```
lavap rpcprovider evmos-provider.yml --from your_key_name_here --geolocation 1 --chain-id lava-testnet-2 --log_level debug
```

Test the provider
```
lavap test rpcprovider --from your_key_name_here --endpoints "evmos.your-site:443,EVMOS"
```

Stake the Provider
```
lavap tx pairing stake-provider EVMOS "50000000000ulava" "evmos.your-site:443,1" 1 [validator_address] --from your_key_name_here --provider-moniker your-provider-moniker-1 --gas-adjustment "1.5" --gas "auto" --gas-prices "0.0001ulava" --chain-id lava-testnet-2 --delegate-limit 0ulava
```

Final test!
```
lavap test rpcprovider --from your_key_name_here --endpoints "evmos.your-site:443,EVMOS"
```

Congratulations, you are now an Evmos RPC Provider!


===============

[Main](https://github.com/zachzwei/z4ch-nodes/blob/main/README.md)
