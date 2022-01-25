#!/bin/bash
set -eu

#- WASP_CLI_SEED=BnKA2LX3HB8WD93RYRNSPXW312GAWS51hBBEhmCGFnJ8
#- WASP_CLI_WASP_API_ADDRESS=127.0.0.1:9090
#- WASP_CLI_WASP_NANOMSG_ADDRESS=127.0.0.1:5550
#- WASP_CLI_WASP_PEERING_ADDRESS=127.0.0.1:4000
#- WASP_CLI_GOSHIMER_API_ADDRESS=iota_dev_goshimmer:8080
#- WASP_CLI_FAUCET_POW_TARGET=-1
#- USE_EVM=0
#- EVM_CHAIN_NAME=evm_chain
#- EVM_CHAIN_DESCRIPTION=EVM-CHAIN
#- EVM_CHAIN_TOKEN_DEPOSIT=10000
#- EVM_CHAIN_ALLOC_ADDRESS=0xB6b6BB13151B85e3eDBd1F9903de4e2606F95a3F
#- EVM_CHAIN_ALLOC_TOKENS=1000000000000000000000000
#- EVM_CHAIN_ID=1074
#- EVM_START_JSONRPC=0

txStreamPort="$(jq -r '.nodeconn.address' /etc/wasp_config.json | grep -o ':[0-9]*$' | grep -o '[0-9]*')"
txStreamPort=${txStreamPort:-5000}
goshimmerAddress="$(jq -r '.nodeconn.address' /etc/wasp_config.json | grep -o '.\+:' | rev | cut -c 2- | rev)"
goshimmerAddress=${goshimmerAddress:-$(jq -r '.nodeconn.address' /etc/wasp_config.json)}

attempt_counter=0
max_attempts=15

echo "Waiting for goshimmer txstream port to be open port: ${txStreamPort}, address: ${goshimmerAddress}"
until $(nc -z ${goshimmerAddress} ${txStreamPort}); do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Max attempts reached"
      exit 1
    fi

    attempt_counter=$(($attempt_counter+1))
    sleep 5
done

echo "Starting wasp..."
wasp -c /etc/wasp_config.json &

attempt_counter=0
max_attempts=15

echo "Waiting for goshimmer + txstream, pinging at: ${WASP_CLI_GOSHIMER_API_ADDRESS} and checking netstat..."
until [[ "$(curl -s -X GET "${WASP_CLI_GOSHIMER_API_ADDRESS}/info" -H  "accept: application/json"|jq '.tangleTime.synced')" == "true" ]] && [[ ! -z "$(netstat -n | awk '{print $5,$6}' | grep -i '\(.*5000.*ESTABLISHED\)')" ]]; do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Max attempts reached"
      exit 1
    fi

    attempt_counter=$(($attempt_counter+1))
    sleep 5
done

echo "Waiting 5 seconds for things to settle..."
sleep 5

if [[ ! $(findmnt -M "/etc/wasp-cli.json") ]]; then
    echo "wasp-cli json is not a mountpoint, setting wasp-cli config vars"
    if [ ! -f /etc/wasp-cli.json ]; then
        wasp-cli init -c /etc/wasp-cli.json
    fi

    wasp-cli set goshimmer.api "${WASP_CLI_GOSHIMER_API_ADDRESS}" -c /etc/wasp-cli.json
    wasp-cli set wasp.0.api "${WASP_CLI_WASP_API_ADDRESS}" -c /etc/wasp-cli.json
    wasp-cli set wasp.0.nanomsg "${WASP_CLI_WASP_NANOMSG_ADDRESS}" -c /etc/wasp-cli.json
    wasp-cli set wasp.0.peering "${WASP_CLI_WASP_PEERING_ADDRESS}" -c /etc/wasp-cli.json

    tmp=$(mktemp)
    jq --arg a "$WASP_CLI_FAUCET_POW_TARGET" '.goshimmer.faucetpowtarget = $a' /etc/wasp-cli.json > "$tmp" && mv "$tmp" /etc/wasp-cli.json
fi

balance=$(wasp-cli balance -c /etc/wasp-cli.json | grep -o 'IOTA.\+[0-9]\+' | awk '{print $2}')
balance=${balance:-0}

echo "Wallet IOTA Balance is: $balance"

if [[ $balance == "0" ]]; then
    echo "Requesting funds from faucet!"
    wasp-cli request-funds -c /etc/wasp-cli.json
fi

parameterHash=$(echo -n "${EVM_CHAIN_NAME}:${EVM_CHAIN_ID}:${EVM_FLAVOUR}:${EVM_CHAIN_ALLOC_ADDRESS}:${EVM_CHAIN_ALLOC_TOKENS}" | sha1sum | awk '{print $1}')
evmDescription="EVM:${parameterHash}"
chainIds=($(wasp-cli chain list -c /etc/wasp-cli.json |  awk 'NR>4{print $1;}' | awk '{print $1}'))

echo "IMPLEMENT: Validating EVM"
if [[ ${USE_EVM} == 1 ]]; then
    if [[ ! -f /wasp/evm-deployed ]]; then
        wasp-cli chain deploy --committee=0 --quorum=1 --chain="${EVM_CHAIN_NAME}" --description="${EVM-CHAIN}" -c /etc/wasp-cli.json
        wasp-cli chain deposit IOTA:10000 -a ${EVM_CHAIN_NAME} -c /etc/wasp-cli.json
        wasp-cli chain evm deploy -a ${EVM_CHAIN_NAME} --description "${evmDescription}" --chainid ${EVM_CHAIN_ID} --gas-per-iota 0 --evm-flavor ${EVM_FLAVOUR} --alloc ${EVM_CHAIN_ALLOC_ADDRESS}:${EVM_CHAIN_ALLOC_TOKENS} -c /etc/wasp-cli.json
        touch /wasp/evm-deployed
    fi
    if [[ ${EVM_START_JSONRPC} == 1 ]]; then
        wasp-cli chain evm jsonrpc --name ${EVM_FLAVOUR} --chainid "${EVM_CHAIN_ID}" -c /etc/wasp-cli.json &
    fi
fi

wait -n
exit $