
Lava leverages the Cosmos SDK's bank and account modules for seamless integration with existing Cosmos wallets.

**Recommendation**: After setting up your wallet, it's crucial to test its functionality. Utilize the [faucet](/faucet#discord-faucet) to acquire testnet tokens. Then, execute a transaction by transferring these tokens to another account and back.

## Choosing a Wallet

Go here https://docs.lavanet.xyz/wallet and follow the guide for installing Keplr Wallet
You can use that to receive your Lava Testnet tokens from Lava team.

### Adding a Key (Wallet) to Node

Ensure you understand the implications of storing your private key in your chosen keyring.

1. Substitute $ACCOUNT_NAME with your desired account name:
```bash
current_lavad_binary="$HOME/.lava/cosmovisor/current/bin/lavad"
ACCOUNT_NAME="name_here"
$current_lavad_binary keys add $ACCOUNT_NAME
```


Securely store your mnemonic in a safe location, as it cannot be retrieved once lost.


2. Verify and locate your account in the keys list:
```bash
$current_lavad_binary keys show $ACCOUNT_NAME
$current_lavad_binary keys list
```

Pencils out 📝
Your public address begins with lava@.


#### Account Recovery

1. Recover an existing account using your mnemonic:
```bash
lavad keys add $NEW_NAME --recover
```
After entering your seed phrase:
```bash
$current_lavad_binary keys show $ACCOUNT_NAME
```
