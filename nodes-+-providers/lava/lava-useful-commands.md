# Useful Lava CLI

Note:

* The following commands is what I use for my own Providers. Please make sure to change some variables based on your own configurations.

***

#### Add new wallet

```
lavad keys add wallet
```

#### Recover existing wallet (using seed phrase)

```
lavad keys add wallet --recover
```

#### List all keys

```
lavad keys list
```

***

#### Send tokens

```
lavad tx bank send <name_wallet> <address> 1000000ulava --fees 5000ulava -y
```

***

#### Stake/Restake Provider

```
lavap tx pairing stake-provider LAVA "5000000000ulava" "lava.z4ch.xyz:443,2" 2 lava@valoper1jt9w26mpxxjsk63mvd4m2ynj0af09csl0sjyut --from z4ch2 --provider-moniker z4ch-lava2  --delegate-limit "0ulava" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```

#### Redelagate tokens

```
lavad tx staking redelegate [old_val] [new_val] [amount_tokens]ulava --from [wallet] --chain-id lava-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001ulava -y
```

***

#### Freeze provider

```
lavap tx pairing freeze LAVA --from z4ch --reason "maintenance" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```

#### Unfreeze provider

```
lavap tx pairing unfreeze LAVA --from z4ch --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```

#### Check accounts (delegations/frozen)

```
lavad q pairing account-info --from z4ch
```

***

#### Check relay payments

```
lavap test events 200 --event lava_relay_payment --from z4ch
```

This command will scan events with "lava\_relay\_payment" from 200 blocks then forward. You can set a different number.

```
lavap test events 0 --event lava_relay_payment --from z4ch
```

This command will scan events wit "lava\_relay\_paymnet" from current block then forward. You need to manually stop the command to stop the logs.

Check QoS

```
lavad test events 200 --show-attribute Excellence  --from z4ch
```

#### Get Provider Rewards

```
lavad tx dualstaking claim-rewards --from z4ch --gas-prices 1ulava --gas-adjustment 1.5 --gas auto -y
```

***

#### Test Provider

```
lavap test rpcprovider --from z4ch
```

#### Start/Stop/Restart Provider

```
sudo systemctl start lavap
sudo systemctl stop lavap
sudo systemctl restart lavap
```

#### Start/Stop/Restart Lava Node

```
sudo systemctl start lavad
sudo systemctl stop lavad
sudo systemctl restart lavad
```

#### Upgrade provider

```
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout <check newest release>

export LAVA_BINARY=lavap
make install
```

#### Alias commands

Wallet Specific

```
# general commands
echo "alias reward='lavad q pairing provider-monthly-payout z4ch'" >> ~/.bashrc
echo "alias reward2='lavad q pairing provider-monthly-payout z4ch2'" >> ~/.bashrc
echo "alias testprovider='lavap test rpcprovider --from z4ch'" >> ~/.bashrc
echo "alias statsprovider='lavad q pairing account-info --from z4ch'" >> ~/.bashrc


# Source the .bashrc file automatically to apply the changes
source ~/.bashrc
```

LAVA (lava) commands

```
# lava commands
echo "alias lavapeers='sudo netstat -anp | grep ESTABLISHED | grep lavad | grep -v \127.0.0.1'" >> ~/.bashrc
echo "alias lavasync='lavad status 2>&1 | jq .SyncInfo'" >> ~/.bashrc
echo "alias lavalogs='sudo journalctl -u lava.service -f --no-hostname -o cat'" >> ~/.bashrc
echo "alias lavastart='sudo systemctl start lava.service'" >> ~/.bashrc
echo "alias lavastop='sudo systemctl stop lava.service'" >> ~/.bashrc
source ~/.bashrc
```

Cosmos (gaia) commands

```
# gaia commands
echo "alias gaiapeers='sudo netstat -anp | grep ESTABLISHED | grep gaiad | grep -v \127.0.0.1'" >> ~/.bashrc
echo "alias gaiasync='gaiad status 2>&1 | jq .sync_info'" >> ~/.bashrc
echo "alias gaialogs='sudo journalctl -u cosmoshub.service -f --no-hostname -o cat'" >> ~/.bashrc
echo "alias gaiastart='sudo systemctl start cosmoshub.service'" >> ~/.bashrc
echo "alias gaiastop='sudo systemctl stop cosmoshub.service'" >> ~/.bashrc
source ~/.bashrc
```

Stargaze (stars) commands

```
# stars commands
echo "alias starspeers='sudo netstat -anp | grep ESTABLISHED | grep starsd | grep -v \127.0.0.1'" >> ~/.bashrc
echo "alias starssync='curl -s http://127.0.0.1:16457/status | jq .result.sync_info'" >> ~/.bashrc
echo "alias starslogs='sudo journalctl -fu stargaze'" >> ~/.bashrc
echo "alias starsstart='sudo service stargaze start'" >> ~/.bashrc
echo "alias starsstop='sudo service stargaze stop'" >> ~/.bashrc
source ~/.bashrc
```

Evmos (evmos) commands

```
# evmos commands
echo "alias evmospeers='sudo netstat -anp | grep ESTABLISHED | grep evmosd | grep -v \127.0.0.1'" >> ~/.bashrc
echo "alias evmossync='evmosd status 2>&1 | jq .SyncInfo'" >> ~/.bashrc
echo "alias evmoslogs='sudo journalctl -u evmosd -f --no-hostname -o cat'" >> ~/.bashrc
echo "alias evmosstart='sudo systemctl start evmosd'" >> ~/.bashrc
echo "alias evmosstop='sudo systemctl stop evmosd'" >> ~/.bashrc
source ~/.bashrc
```

Check LISTEN ports

```
# lava
netstat -tulpn | grep LISTEN | grep "lavad"

#gaia
netstat -tulpn | grep LISTEN | grep "gaiad"

#evmos
netstat -tulpn | grep LISTEN | grep "evmosd"

#stars
netstat -tulpn | grep LISTEN | grep "starsd"
```

Check if PORT is open

Replace $PORT with PORT number you want to check

```
sudo lsof -i:$PORT
```

