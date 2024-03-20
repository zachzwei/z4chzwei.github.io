# Starknet Provider Setup

The steps for creating a provider will be similar to the [Lava Provider Setup](https://github.com/zachzwei/z4ch-nodes/blob/main/lava/lava-provider-tls.md).

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


===============

In case you are getting errors with your test.

Check if port `6061` is in use/open
```
ss -na | grep :6061
```

If it is not in use, open port `6061`

```
sudo ufw allow 6061
```

