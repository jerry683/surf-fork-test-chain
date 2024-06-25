#!/bin/bash
set -exo pipefail

# dydxprotocold 替换 ip地址 ！！！！
./dydxprotocold start --home ./chain/.surf1 --p2p.persistent_peers "17e5e45691f0d01449c84fd4ae87279578cdd7ec@dydxprotocold0:26656,b69182310be02559483e42c77b7b104352713166@dydxprotocold1:26656,47539956aaa8e624e0f1d926040e54908ad0eb44@dydxprotocold2:26656,5882428984d83b03d0c907c1f0af343534987052@dydxprotocold3:26656" --bridge-daemon-eth-rpc-endpoint https://eth-sepolia.g.alchemy.com/v2/demo