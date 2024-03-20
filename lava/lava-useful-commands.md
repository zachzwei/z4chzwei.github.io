Note: 

* The following commands is what I use for my own Providers. Please make sure to change some variables based on your own configurations.

**********
Add new wallet
```
lavad keys add wallet
```
Recover existing wallet (using seed phrase)
```
lavad keys add wallet --recover
```
List all keys
```
lavad keys list
```
**********

Send tokens
```
lavad tx bank send <name_wallet> <address> 1000000ulava --fees 5000ulava -y
```
**********
Stake/Restake Provider
```
lavap tx pairing stake-provider LAV1 "50000000000ulava" "lava.z4ch.xyz:443,2" 2 lava@valoper1jt9w26mpxxjsk63mvd4m2ynj0af09csl0sjyut --from z4ch2 --provider-moniker z4ch-lava2  --delegate-limit "0ulava" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```
Redelagate tokens
```
lavad tx staking redelegate [old_val] [new_val] [amount_tokens]ulava --from [wallet] --chain-id lava-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001ulava -y
```
**********
Freeze provider
```
lavap tx pairing freeze LAV1 --from zach2 --reason "maintenance" --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```
Unfreeze provider
```
lavap tx pairing unfreeze LAV1 --from z4ch2 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```
Check accounts (delegations/frozen)
```
lavad q pairing account-info --from z4ch2
```
**********
Check relay payments
```
lavap test events 200 --event lava_relay_payment --from z4ch2
```
**********
Check free space. Need [NCDU](https://ostechnix.com/check-disk-space-usage-linux-using-ncdu/) installed.
```
ncdu -x /
```
