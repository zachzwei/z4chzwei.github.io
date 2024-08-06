# Lave Wallet Setup

Warning!

Make sure your node is fully synced before proceeding.

### Adding a Key (Wallet) to Node

Ensure you understand the implications of storing your private key in your chosen keyring.

1. Substitute $ACCOUNT\_NAME with your desired account name:

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

Pencils out 📝 Your public address begins with lava@.

### Restore a Wallet

1. Recover an existing account using your mnemonic:

```bash
lavad keys add $NEW_NAME --recover
```

After entering your seed phrase:

```bash
$current_lavad_binary keys show $ACCOUNT_NAME
```
