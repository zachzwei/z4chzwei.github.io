# Lava Provider Setup

All providers on `lava-mainnet-1` must use a domain name and TLS (1.3). You must have a domain name to continue. If you have not already, please take a moment to purchase one! You can find cheap top-level domains [here](https://www.namecheap.com/) or [here](https://tld-list.com/).

### Setup Domain

#### Modify DNS settings

The first step of establishing your Provider is to modify some of the DNS settings on the domain you purchased. In specific, you'll need to change the A Records on your domain.&#x20;

![](<../../.gitbook/assets/image (19).png>)\


### Configure Nginx

#### Install dependencies

```bash
sudo apt update
sudo apt install certbot net-tools nginx python3-certbot-nginx -y
```

Generate Certificate

Use `certbot` to create a certificate:

```
sudo certbot certonly -d your-site.com -d lava.your-site.com -d eth.your-site.com
```

#### Validate Certificate

Note: ✅ `your-site.com` refers to the Domain name that you purchased and configured.

Let's make sure your certificate successfully installed! ✅ Input the following command:

```
sudo certbot certificates
```

Keep track of your output. If your certificate generation was successful, it should look as following:

`Found the following certs: Certificate Name: your-site.com Domains: your-site.com eth.your-site.com lava.your-site.com Expiry Date: 2023-11-07 14:37:29+00:00 (VALID: 84 days) Certificate Path: /etc/letsencrypt/live/your-site.com/fullchain.pem Private Key Path: /etc/letsencrypt/live/your-site.com/privkey.pem`

You'll need both `Certificate Path` and `Private Key Path` for your next step.

#### Add an Nginx Config for Each Domain

Note: ✅ `your-site.com` refers to the Domain name that you purchased and configured.

Lava recommends running each chain under a separate provider process. This will separate error logs and protect against complete provider failure in the case of a problematic provider process. The first step of this is to create different nginx routes for each chain.

For each chain that you want to support, you will need to create a separate `nginx` config file. `cd` into `/etc/nginx/sites-available/` and create a `server` file for each chain. You will need to select an open port for each chain. `Nginx` will use these config files to create your routes.

```
cd
cd /etc/nginx/sites-available/
```

Create the server file. For this guide, we will focus on `lava_server`

```
sudo nano lava_server
```

Copy and paste the text below. Save your `lava_server` file.

```
server {
    listen 443 ssl http2;
    server_name lava.your-site.com;

    ssl_certificate /etc/letsencrypt/live/your-site.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-site.com/privkey.pem;
    error_log /var/log/nginx/debug.log debug;

    location / {
        proxy_pass http://127.0.0.1:26657;
        grpc_pass 127.0.0.1:26657;
    }
}
```

In most cases, after creating a configuration file in accessible sites, you need to create a symbolic link to this file in the enabled sites directory. This can be done with a command like:

```
sudo ln -s /etc/nginx/sites-available/lava_server /etc/nginx/sites-enabled/lava_server
```

#### Test Nginx Configuration

Now, ensure that your `nginx` setup is working! ✅

```bash
sudo nginx -t
```

🖳 Expected Output:

`nginx: the configuration file /etc/nginx/nginx.conf syntax is ok`

`nginx: configuration file /etc/nginx/nginx.conf test is successful`

#### Restart Nginx

You will need to refresh the Nginx server:

```bash
sudo systemctl restart nginx
```

#### Secure NGINX With Let’s Encrypt&#x20;

Steps were taken here:&#x20;

[https://www.kamatera.com/knowledgebase/how-to-secure-nginx-with-lets-encrypt/](https://www.kamatera.com/knowledgebase/how-to-secure-nginx-with-lets-encrypt/)

Run the following commands:

```
sudo certbot --nginx -d <your-site>
```

Test auto renewal

```
sudo certbot renew --dry-run
```

Visit your site on HTTPS to check. Open a browser and then type `https://your-site.com`

If it shows a padlock or something like this then you are good to go.

<figure><img src="../../.gitbook/assets/image (32).png" alt=""><figcaption><p>HTTPS enabled</p></figcaption></figure>

### Install Lavap

Since you are already running a node, you just need to configure the `lavap` service.

```
cd lava
git checkout v3.1.0
export LAVA_BINARY=lavap
make install
```

This will install v3.1.0 of lavap.

### Create the Provider Configuration

Copy and run the following to generate a lava.yml file in your /config folder.

The port numbers will be automatically added based on your node configuration. The RPC port will use 26657. You can change this to any port. Just make sure you use the same port you have configured for your domain.

```
RPC=$(cat $HOME/.lava/config/config.toml | sed -n '/TCP or UNIX socket address for the RPC server to listen on/{n;p;}' | sed 's/.*://; s/".*//')
GRPC=$(cat $HOME/.lava/config/app.toml | sed -n '/Address defines the gRPC server address to bind to/{n;p;}' | sed 's/.*://; s/".*//')
API=$(cat $HOME/.lava/config/app.toml | sed -n '/Address defines the API server to listen on./{n;p;}' | sed 's/.*://; s/".*//')

echo "RPC:"$RPC "GRPC:"$GRPC "API:"$API

mkdir $HOME/config
sudo tee << EOF >/dev/null $HOME/config/lava.yml
endpoints:
  - api-interface: tendermintrpc
    chain-id: LAVA
    network-address:
      address: 0.0.0.0:2224
      disable-tls: true
    node-urls:
      - url: ws://127.0.0.1:$RPC/websocket
      - url: http://127.0.0.1:$RPC
  - api-interface: grpc
    chain-id: LAVA
    network-address:
      address: 0.0.0.0:2224
      disable-tls: true
    node-urls:
      url: 127.0.0.1:$GRPC
  - api-interface: rest
    chain-id: LAVA
    network-address:
      address: 0.0.0.0:2224
      disable-tls: true
    node-urls:
      url: http://127.0.0.1:$API
EOF
```

#### Where to find ports?

You can find the following port numbers on the `config.toml` and `app.toml` files located at `./lava/config` folder.

* Tendermint RPC

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/ea9fb74d-cd93-46de-af01-06a22df55291)

* GRPC

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/2e348821-005f-4892-8808-f162d5d297f9)

* Rest (API)

![image](https://github.com/zachzwei/z4ch-nodes/assets/35627271/fdc357a1-54a9-4dd7-b64e-bea7ec7725ec)\


#### Note:

Set the geolocation value depending on where your server is located.

```
    GLS = 0; // Global-strict
    USC = 1; // US-Center
    EU = 2; // Europe
    USE = 4; // US-East
    USW = 8; // US-West
    AF = 16; // Africa
    AS = 32; // Asia
    AU = 64;  // (Australia, includes NZ)
    GL = 65535; // Global
```

### Start the Provider

To start the Lava provider process, run the following command

```
lavap rpcprovider lava.yml --reward-server-storage /.lava/rewardserver --geolocation 2 --from z4ch --chain-id lava-mainnet-1 --keyring-backend file --log_level debug
```

Test the Provider Process!

Run the following command:

```
lavap test rpcprovider --from your_key_name_here --endpoints "your-site:443,LAVA"
```

🖳 Expected output:

```
📄----------------------------------------✨SUMMARY✨----------------------------------------📄

🔵 Tests Passed:
🔹LAV1-grpclatest block: 0x4ca8c
🔹LAV1-restlatest block: 0x4ca8c
🔹LAV1-tendermintrpclatest block: 0x4ca8c

🔵 Tests Failed:
🔹None 🎉! all tests passed ✅

🔵 Provider Port Validation:
🔹✅ All Ports are valid! ✅

```

❗ Make sure the tests are all passed before you stake your tokens.

### Stake the Provider on Chain

Use a variation of the following command to stake on chain; the minimum stake is `5000000000ulava or 5,000 LAVA`

```bash
MONIKER="Provider Name"
DOMAIN="Provider Domain URL"
PORT=443
echo $MONIKER $DOMAIN $PORT
lavap tx pairing stake-provider LAVA "5000000000ulava" "$DOMAIN:$PORT,[2]" [2] [validator] --from [wallet_name] --provider-moniker "$MONIKER"  --delegate-limit "1000000000000ulava" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```

Example:

`lavap tx pairing stake-provider LAVA "5000000000ulava" "lava.z4ch.xyz:443,2" 2 lava@valoper1amkaaut9fs395v3vpuymp6zmggva32mkkvr7rq --from z4ch --provider-moniker "zwei node" --delegate-limit "1000000000000ulava" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y`

Some notes:

* `[validator]` you need to indicate a validator address, choose here: [https://lava.explorers.guru/validators](https://lava.explorers.guru/validators)
* `[2]` replace this with the corresponding geolocation of your server
* `--from` should be followed by the key name of your funded account that you will use to stake your provider
* `--provider-moniker` will be the name of your provider

#### Congratulations, your LAVA Provider is now up and running.



### Updating Lava Provider

Since you are running `lavap` without `lavavisor` if there are updates necessary, you would have to manually run an update. Here are the steps to do so.

1. Close all running Provider process `CTRL+C`
2. Delete the current `lava` folder and download the most recent version. Check the [latest release](https://github.com/lavanet/lava/releases) available.

```
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout <check newest release>
```

3. Build the `lavap` binaries.

```
export LAVA_BINARY=lavap
make install
```

4. Check `lavap` version

```
lavap version
```

5. Run Test to confirm. Then if all test passed, run Provider process.

### Addtiional Commands

Modify Provider

```
lavad tx pairing modify-provider LAVA
```

Get Provider Details

```
lavap q pairing account-info --from [wallet_name]
```

Get Provider Rewards

```
lavad tx dualstaking claim-rewards --from z4ch --gas-prices 1ulava --gas-adjustment 1.5 --gas auto -y
```

❗ If you have any further issues, do not hesitate to venture to our [discord](https://discord.com/invite/Tbk5NxTCdA) where you can get better assistance!
