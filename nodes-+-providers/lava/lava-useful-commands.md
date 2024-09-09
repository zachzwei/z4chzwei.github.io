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
lavap tx pairing freeze LAVA --from zach --reason "maintenance" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
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
lavap test 0 --event lava_relay_payment --from z4ch
```

This command will scan events wit "lava\_relay\_paymnet" from current block then forward. You need to manually stop the command to stop the logs.

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

Check free space. Need [NCDU](https://ostechnix.com/check-disk-space-usage-linux-using-ncdu/) installed.

```
ncdu -x /
```
