#!/bin/bash
set -e

echo "Container's IP address: `awk 'END{print $1}' /etc/hosts`"

if [[ -z "$(./wasp-cli -c ./wasp-cli.json chain info | grep "Test EVM")" ]]; then
    chmod +x ./wasp-cli
    ./wasp-cli request-funds -w
    ./wasp-cli chain deploy --committee=0 --quorum=1 --chain=test-evm --description="Test EVM" -w
    ./wasp-cli chain deposit IOTA:10000 -w 
    ./wasp-cli chain evm deploy -a test-evm --alloc 0x9C0B7a35B957F23b83677C6429F1F393027A9E62:1000000000000000000000000 --chainid 1075 -w
fi

./wasp-cli chain evm jsonrpc --chainid 1075
