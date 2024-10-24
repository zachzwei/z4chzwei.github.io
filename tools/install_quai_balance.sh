#!/bin/bash

# Update system package index
sudo apt update

# Install Python3 if not already installed
if ! command -v python3 &> /dev/null
then
    echo "Python3 not found. Installing Python3..."
    sudo apt install -y python3
else
    echo "Python3 is already installed."
fi

# Install pip3 if not already installed
if ! command -v pip3 &> /dev/null
then
    echo "pip3 not found. Installing pip3..."
    sudo apt install -y python3-pip
else
    echo "pip3 is already installed."
fi

# Install requests library
echo "Installing requests library..."
pip3 install requests

# Create the Python script
echo "Creating Python script 'quaibal.py'..."

cat <<EOL > quaibal.py
#!/usr/bin/env python3

import requests
import json

# The URL for the RPC request
url = "https://rpc.quai.network/cyprus1/"

# Ask the user to input the wallet address
wallet_address = input("Please enter the wallet address: ")

# The request payload, with the wallet address provided by the user
payload = {
    "jsonrpc": "2.0",
    "method": "quai_getBalance",
    "params": [
        wallet_address,  # Use the input wallet address here
        "latest"
    ],
    "id": 1
}

# The headers for the request
headers = {
    'Content-Type': 'application/json'
}

# Make the POST request
response = requests.post(url, headers=headers, data=json.dumps(payload))

# Parse the response
result = response.json()

# Check if the result contains a valid balance
if 'result' in result:
    # Get the balance from the response (in hexadecimal)
    balance_hex = result['result']  # e.g., "0x38d7ea4c68000"

    # Convert from hex to integer
    balance_int = int(balance_hex, 16)

    # Convert to the correct format (divide by 10^18 for 18 decimal places)
    balance_decimal = balance_int / 10**18

    # Output the result
    print(f"Balance: {balance_decimal:.18f} tokens")
else:
    print(f"Error: {result.get('error', 'Unknown error occurred')}")
EOL

# Make the Python script executable
chmod +x quaibal.py

# Success message
echo "Installation complete! You can now run the script with the command: ./quaibal.py"
