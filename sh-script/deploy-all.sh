set -e # Exit on error

source .env

forge script script/multichain-setup/AribitrumAcrossRelayer.s.sol --rpc-url $ARBITRUM_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/BaseAcrossRelayer.s.sol --rpc-url $BASE_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/BlastAcrossRelayer.s.sol --rpc-url $BLAST_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/EtherreumAcrossRelayer.s.sol --rpc-url $ETHEREUM_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/LineaAcrossRelayer.s.sol --rpc-url $LINEA_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/LiskAcrossRelayer.s.sol --rpc-url $LISK_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000 
forge script script/multichain-setup/ModeAcrossRelayer.s.sol --rpc-url $MODE_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/OptimismAcrossRelayer.s.sol --rpc-url $OPTIMISM_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/PolygonAcrossRelayer.s.sol --rpc-url $POLYGON_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/RedstoneAcrossRelayer.s.sol --rpc-url $REDSTONE_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/ScrollAcrossRelayer.s.sol --rpc-url $SCROLL_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/ZkSyncAcrossRelayer.s.sol --rpc-url $ZKSYNC_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000
forge script script/multichain-setup/ZoraAcrossRelayer.s.sol --rpc-url $ZORA_RPC_URL --broadcast --with-gas-price 100000000 --optimizer-runs 8000