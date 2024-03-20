# Starknet Node Setup

### Prerequisites

- Golang 1.20 or higher is required to build and run the project. You can find the installer on
  the official Golang [download](https://go.dev/doc/install) page.
- Docker Engine (https://docs.docker.com/engine/install/)
- [Rust](https://www.rust-lang.org/tools/install).
- A C compiler: `gcc` or `clang`.
- Lava account (https://gateway.lavanet.xyz/)
- Lava points (optional) (https://points.lavanet.xyz/register?code=3HAC1)

Note:

`The following instructions include downloading a snapshot first before running your node. The port was changed to 6065 since Lava uses 6060 by default.`

==========

### Download Snapshot

Use the provided snapshots to quickly sync your Juno node with the current state of the network. 

#### Mainnet

| Version | Size | Block | Download Link |
| ------- | ---- | ----- | ------------- |
| **>=v0.9.2**  | **156 GB** | **519634** | [**juno_mainnet.tar**](https://juno-snapshots.nethermind.dev/mainnet/juno_mainnet_v0.9.3_519634.tar) |

   Fetch the snapshot from the provided URL:

   ```
   wget -O juno_mainnet.tar https://juno-snapshots.nethermind.dev/mainnet/juno_mainnet_v0.9.3_519634.tar
   ```

### Prepare Directory

   Ensure you have a directory at `$HOME/snapshots`. If it doesn't exist yet, create it:

   ```
   mkdir -p $HOME/snapshots
   ```

### Extract Tarball

   Extract the contents of the `.tar` file:

   ```
   tar -xvf juno_mainnet.tar -C $HOME/snapshots
   ```

### Obtain ETH WS RPC

Get `<YOUR-ETH-WS-NODE> `from your Lava account.

<img width="898" alt="image" src="https://github.com/zachzwei/juno-starknet-node/assets/35627271/df213c6b-dcc1-40e3-928b-863aafdb7075">

### Run Juno Starknet Node

Execute the Docker command to run Juno, ensuring that you're using the correct snapshot path `$HOME/snapshots/juno_mainnet`:

   ```bash
   docker run -d \
     --name juno \
     -p 6065:6065 \
     -v $HOME/snapshots/juno_mainnet:/var/lib/juno \
     nethermind/juno:latest \
     --http \
     --http-port 6065 \
     --http-host 0.0.0.0 \
     --db-path /var/lib/juno \
     --eth-node <YOUR-ETH-WS-NODE>
   ```
After following these steps, Juno should be up and running on your machine, utilizing the provided snapshot.

### View Logs

To view logs from the Docker container, use the following command:

```
docker logs -f juno
```
==========

### Updating Juno:

Stop and remove old version
```
docker stop juno
```
```
docker rm juno
```
Check latest version here: [https://github.com/NethermindEth/juno/releases](https://github.com/NethermindEth/juno/releases)

Replace `latest` with the most current version available.
```
docker pull nethermind/juno:<latest>
```
Start node with this new version.
```
docker run -d \
--name juno \
-p 6065:6065 \
-v $HOME/snapshots/juno_mainnet:/var/lib/juno \
nethermind/juno:<latest> \
--http \
--http-port 6065 \
--http-host 0.0.0.0 \
--db-path /var/lib/juno \
--eth-node <YOUR-ETH-WS-NODE>
```

[Update Juno](https://juno.nethermind.io/updating_node)

[Provider Setup](https://github.com/zachzwei/z4ch-nodes/edit/main/starknet/stark-provider-tls.md)

[Main](https://github.com/zachzwei/z4ch-nodes)

