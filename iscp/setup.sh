#!/usr/bin/env bash

cd "${0%/*}"

if [ -f setup.conf ]; then
    read -r -p "A config file exists and will be overwritten, are you sure you want to continue? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
        mv setup.conf setup.conf_backup
        chmod 600 setup.conf_backup
        ;;
        *)
        exit 1
        ;;
    esac
fi

whiptail --title "ISCP Chain Configuration" --msgbox "Enter the necessary information for the initial setup." 8 78

DOMAINNAME=$(whiptail --inputbox "Please enter your Domain-Name" 8 78 --title "Domain-Name" 3>&1 1>&2 2>&3 )

whiptail --title "EVM" --yesno "Do you want to enable the EVM?" --no-button "No" --yes-button "Yes" 8 78 
USE_EVM=$?

if [ $USE_EVM=0 ]; then
    METAMASK_ADRESS=$(whiptail --inputbox "Please enter your Metamask address" 8 78 --title "Metamask-Address" 3>&1 1>&2 2>&3 )

    EVM_CHAIN_ID=$(whiptail --inputbox "Please enter an unused Chain-ID" 8 78 --title "Chain-ID" 3>&1 1>&2 2>&3 )

    EVM_CHAIN_NAME=$(whiptail --inputbox "Please enter a name for your EVM Chain" 8 78 --title "Chain-Name" 3>&1 1>&2 2>&3 )

    whiptail --title "EVM-Flavour" --yesno "Which EVM-Flavour would you like to enable?" --no-button "EVM-Light" --yes-button "EVM" 8 78 
    EVM_FLAVOUR=$?

    whiptail --title "JSON-RPC" --yesno "Do you want to enable the JSON-RPC on startup?" --no-button "No" --yes-button "Yes" 8 78
    START_JSONRPC=$?
fi

cat << EOF > setup.conf
    DOMAINNAME=$DOMAINNAME
    GOSHIMMER_DASHBOARD_HOSTNAME=goshimmer.sc.$DOMAINNAME
    GOSHIMMER_PROMETHEUS_DASHBOARD_HOSTNAME=prometheus.goshimmer.sc.$DOMAINNAME
    GOSHIMMER_API_HOSTNAME=api.goshimmer.sc.$DOMAINNAME
    WASP_DASHBOARD_HOSTNAME=wasp.sc.$DOMAINNAME
    WASP_API_HOSTNAME=api.wasp.sc.$DOMAINNAME
    WASP_EVM_HOSTNAME=evm.wasp.sc.$DOMAINNAME
    BLOCKSCOUT_HOSTNAME=explorer.wasp.sc.$DOMAINNAME  
    GOSHIMMER_NODE_SEED=base58:3vijZrJe2BsP39dr3FqPBWoZYJtDS9qhYoFts7GqJSKn
    USE_EVM=$USE_EVM
    EVM_FLAVOUR=$EVM_FLAVOUR
    START_JSONRPC=$START_JSONRPC
    WASP_CLI_WASP_API_ADDRESS=iota_dev_wasp:9090
    WASP_CLI_WASP_NANOMSG_ADDRESS=127.0.0.1:5550
    WASP_CLI_WASP_PEERING_ADDRESS=127.0.0.1:4000
    WASP_CLI_GOSHIMER_API_ADDRESS=iota_dev_goshimmer:8080
    WASP_CLI_FAUCET_POW_TARGET=-1
    EVM_CHAIN_NAME=${EVM_CHAIN_NAME}
    EVM_CHAIN_DESCRIPTION=EVM-CHAIN
    EVM_CHAIN_TOKEN_DEPOSIT=10000
    EVM_CHAIN_ALLOC_ADDRESS=${METAMASK_ADRESS:?-}
    EVM_CHAIN_ALLOC_TOKENS=1000000000000000000000000
    EVM_CHAIN_ID=${EVM_CHAIN_ID:?-}
EOF

