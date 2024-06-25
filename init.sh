#!/bin/bash
set -exo pipefail
source "./genesis.sh"

install_prerequisites() {
    # Install dasel and jq using Homebrew
    #brew install dasel jq

    # linux
    # apk add dasel jq
    echo 'install_pre done'
}

# Define mnemonics for all validators.
MNEMONICS=(
	# surf
	# Consensus Address: dydxvalcons1zf9csp5ygq95cqyxh48w3qkuckmpealrw2ug4d
	"merge panther lobster crazy road hollow amused security before critic about cliff exhibit cause coyote talent happy where lion river tobacco option coconut small"
)

TEST_ACCOUNTS=(
	"dydx199tqg4wdlnu4qjlxchpd7seg454937hjrknju4" # surf
)

FAUCET_ACCOUNTS=(
	"dydx1nzuttarf5k2j0nug5yzhr6p74t9avehn9hlh8m" # main faucet
)

MONIKER="surf02"
VAL_HOME_DIR="./.$MONIKER"
VAL_CONFIG_DIR="$VAL_HOME_DIR/config"

rm -rf ./config
rm -rf ./data
rm -rf "$VAL_HOME_DIR"

CHAIN_ID="surf-test-chain"

# The argument $MONIKER is the custom username of your node, it should be human-readable.
./dydxprotocold init $MONIKER --chain-id=$CHAIN_ID --home "$VAL_HOME_DIR"

./dydxprotocold tendermint gen-priv-key --home ./config --mnemonic "${MNEMONICS[0]}"

install_prerequisites

edit_genesis "$VAL_CONFIG_DIR" "${TEST_ACCOUNTS[*]}" "${FAUCET_ACCOUNTS[*]}" "" "" "" ""

echo "${MNEMONICS[0]}" | ./dydxprotocold keys add $MONIKER --recover --keyring-backend=test  --home "$VAL_HOME_DIR"

#cp ./config/genesis.json  "$VAL_CONFIG_DIR"

# Get the address of the newly added key
ADDRESS=$(./dydxprotocold keys show $MONIKER -a --keyring-backend=test --home "$VAL_HOME_DIR")
./dydxprotocold add-genesis-account $ADDRESS 100000000000000000$USDC_DENOM,$TESTNET_VALIDATOR_NATIVE_TOKEN_BALANCE$NATIVE_TOKEN --home "$VAL_HOME_DIR"

./dydxprotocold gentx $MONIKER $TESTNET_VALIDATOR_SELF_DELEGATE_AMOUNT$NATIVE_TOKEN --moniker=$MONIKER --keyring-backend=test --chain-id=$CHAIN_ID --home "$VAL_HOME_DIR"

./dydxprotocold collect-gentxs --home "$VAL_HOME_DIR"

#./dydxprotocold validate-genesis --home "$VAL_HOME_DIR"

./dydxprotocold start --home "$VAL_HOME_DIR" --bridge-daemon-eth-rpc-endpoint https://eth-sepolia.g.alchemy.com/v2/demo


