

# Manual Node setup with Cosmovisor
## Prerequisites

1. Verify [hardware requirements](reqs) are met
2. Install package dependencies
    - Note: You may need to run as `sudo`
    - Required packages installation
        
        
        ### Packages installations
      ```
        sudo apt update # in case of permissions error, try running with sudo
        sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd
      ```
        ### Create the temp dir for the installation
      ```
        temp_folder=$(mktemp -d) && cd $temp_folder
        ```
        
    - Go installation
        
        ### Configurations
      ```
        go_package_url="https://go.dev/dl/go1.20.5.linux-amd64.tar.gz"
        go_package_file_name=${go_package_url##*\/}
      ```
        ### Download GO
      ```
        wget -q $go_package_url
      ```
        ### Unpack the GO installation file
      ```
        sudo tar -C /usr/local -xzf $go_package_file_name
      ```
        ### Environment adjustments
      ```
        echo "export PATH=\$PATH:/usr/local/go/bin" >>~/.profile
        echo "export PATH=\$PATH:\$(go env GOPATH)/bin" >>~/.profile
        source ~/.profile
        ```
        
    - Installation verifications
        
        
        1. You can verify the installed go version by running: `go version`
        
        2. The command `go env GOPATH` should include `$HOME/go`
        If not, then, `export GOPATH=$HOME/go`
        
        3. PATH should include `$HOME/go/bin`
        To verify PATH, run `echo $PATH`
        

## 1. Set up a local node

### Download app configurations

- Download setup configuration
    
    Download the configuration files needed for the installation
    
    ```
    git clone https://github.com/lavanet/lava-config.git
    cd lava-config/testnet-2
    ```
    ### Read the configuration from the file
    ### Note: you can take a look at the config file and verify configurations
    ```
    source setup_config/setup_config.sh
    ```
    
- Set app configurations
        
    Copy lavad default config files to config Lava config folder

    ```
    echo "Lava config file path: $lava_config_folder"
    mkdir -p $lavad_home_folder
    mkdir -p $lava_config_folder
    cp default_lavad_config_files/* $lava_config_folder
    ```
    

### Set the genesis file

- Set the genesis file in the configuration folder
    
    ```
    cp genesis_json/genesis.json $lava_config_folder/genesis.json
    ```

## 2. Join the Lava Testnet

The following sections will describe how to install Cosmovisor for automating the upgrades process.


### Set up Cosmovisor {#cosmovisor}

- Set up cosmovisor to ensure any future upgrades happen flawlessly. To install Cosmovisor:
    
    ```
    go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
    mkdir -p $lavad_home_folder/cosmovisor/genesis/bin/
    wget -O  $lavad_home_folder/cosmovisor/genesis/bin/lavad "https://github.com/lavanet/lava/releases/download/v0.21.1.2/lavad-v0.21.1.2-linux-amd64"
    chmod +x $lavad_home_folder/cosmovisor/genesis/bin/lavad
    ```


- Set the environment variables
    ```
    echo "# Setup Cosmovisor" >> ~/.profile
    echo "export DAEMON_NAME=lavad" >> ~/.profile
    echo "export CHAIN_ID=lava-testnet-2" >> ~/.profile
    echo "export DAEMON_HOME=$HOME/.lava" >> ~/.profile
    echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=true" >> ~/.profile
    echo "export DAEMON_LOG_BUFFER_SIZE=512" >> ~/.profile
    echo "export DAEMON_RESTART_AFTER_UPGRADE=true" >> ~/.profile
    echo "export UNSAFE_SKIP_BACKUP=true" >> ~/.profile
    source ~/.profile
    ```

  - Initialize the chain
    ```
    $lavad_home_folder/cosmovisor/genesis/bin/lavad init \
    my-node \
    --chain-id lava-testnet-2 \
    --home $lavad_home_folder \
    --overwrite
    cp genesis_json/genesis.json $lava_config_folder/genesis.json
    ```

    :::caution Please note that cosmovisor will throw an error ⚠️ This is ok.
    The following error will be thrown,
    lstat /home/ubuntu/.lava/cosmovisor/current/upgrade-info.json: no such file or directory
    :::

    ```
    cosmovisor version
    ```
    
    Create the systemd unit file
    ```
    echo "[Unit]
    Description=Cosmovisor daemon
    After=network-online.target
    [Service]
    Environment="DAEMON_NAME=lavad"
    Environment="DAEMON_HOME=${HOME}/.lava"
    Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
    Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
    Environment="DAEMON_LOG_BUFFER_SIZE=512"
    Environment="UNSAFE_SKIP_BACKUP=true"
    User=$USER
    ExecStart=${HOME}/go/bin/cosmovisor start --home=$lavad_home_folder --p2p.seeds $seed_node
    Restart=always
    RestartSec=3
    LimitNOFILE=infinity
    LimitNPROC=infinity
    [Install]
    WantedBy=multi-user.target
    " >cosmovisor.service
    sudo mv cosmovisor.service /lib/systemd/system/cosmovisor.service
    ```

### Download the latest Lava data snapshot (_optional_) {#snapshots}

    curl -L https://snapshots.kjnodes.com/lava-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
    mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
    
    
### Enable and start the Cosmovisor service
    
- Configure the Cosmovisor service to run on boot, and start it
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable cosmovisor.service
    sudo systemctl restart systemd-journald
    sudo systemctl start cosmovisor
    ```
    

## 3. Verify

### Verify `cosmovisor` setup

Make sure `cosmovisor` is running by checking the state of the cosmovisor service:

- Check the status of the service
    ```
    sudo systemctl status cosmovisor
    ```
- To view the service logs - to escape, hit CTRL+C

    ```
    sudo journalctl -u cosmovisor -f
    ```

### Verify node status

Note the location of `lavad` now exists under `cosmovisor` path:

```
$HOME/.lava/cosmovisor/current/bin/lavad status | jq .SyncInfo.catching_up
```
You will get a response `false` to indicate that the node is fully synced.

You are now running a Node in the Lava network 🎉🥳! 


