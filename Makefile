-include .env

COMMON_DEPLOYMENT_FLAGS := --broadcast --with-gas-price 100000000 --optimizer-runs 8000

start-node :; anvil --fork-url ${ETHEREUM_RPC_URL}

.PHONY: coverage
coverage: 
	./sh-script/coverage.sh

.PHONY: deploy-arbitrum 
deploy-arbitrum:
	forge script script/multichain-setup/AribitrumAcrossRelayer.s.sol --rpc-url ${ARBITRUM_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-base 
deploy-base:
	forge script script/multichain-setup/BaseAcrossRelayer.s.sol --rpc-url ${BASE_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-blast 
deploy-blast:
	forge script script/multichain-setup/BlastAcrossRelayer.s.sol --rpc-url ${BLAST_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-ethereum 
deploy-ethereum:
	forge script script/multichain-setup/EtherreumAcrossRelayer.s.sol --rpc-url ${ETHEREUM_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-linea 
deploy-linea:
	forge script script/multichain-setup/LineaAcrossRelayer.s.sol --rpc-url ${LINEA_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-lisk 
deploy-lisk:
	forge script script/multichain-setup/LiskAcrossRelayer.s.sol --rpc-url ${LISK_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-mode
deploy-mode:
	forge script script/multichain-setup/ModeAcrossRelayer.s.sol --rpc-url ${MODE_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-optimism 
deploy-optimism:
	forge script script/multichain-setup/OptimismAcrossRelayer.s.sol --rpc-url ${OPTIMISM_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-polygon 
deploy-polygon:
	forge script script/multichain-setup/PolygonAcrossRelayer.s.sol --rpc-url ${POLYGON_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-redstone 
deploy-redstone:
	forge script script/multichain-setup/RedstoneAcrossRelayer.s.sol --rpc-url ${REDSTONE_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-scroll 
deploy-scroll:
	forge script script/multichain-setup/ScrollAcrossRelayer.s.sol --rpc-url ${SCROLL_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-zksync 
deploy-zksync:
	forge script script/multichain-setup/ZkSyncAcrossRelayer.s.sol --rpc-url ${ZKSYNC_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-zora 
deploy-zora:
	forge script script/multichain-setup/ZoraAcrossRelayer.s.sol --rpc-url ${ZORA_RPC_URL} $(COMMON_DEPLOYMENT_FLAGS) 

.PHONY: deploy-all
deploy-all:
	./sh-script/deploy-all.sh

.PHONY: test-arbitrum 
test-arbitrum:
	forge test --match-path test/multichain-setup/ArbitrumAcrossRelayer.t.sol

.PHONY: test-base 
test-base:
	forge test --match-path test/multichain-setup/BaseAcrossRelayer.t.sol

.PHONY: test-blast 
test-blast:
	forge test --match-path test/multichain-setup/BlastAcrossRelayer.t.sol

.PHONY: test-ethereum 
test-ethereum:
	forge test --match-path test/multichain-setup/EthereumAcrossRelayer.t.sol

.PHONY: test-linea 
test-linea:
	forge test --match-path test/multichain-setup/LineaAcrossRelayer.t.sol

.PHONY: test-lisk 
test-lisk:
	forge test --match-path test/multichain-setup/LiskAcrossRelayer.t.sol

.PHONY: test-mode
test-mode:
	forge test --match-path test/multichain-setup/ModeAcrossRelayer.t.sol

.PHONY: test-optimism 
test-optimism:
	forge test --match-path test/multichain-setup/OptimismAcrossRelayer.t.sol

.PHONY: test-polygon 
test-polygon:
	forge test --match-path test/multichain-setup/PolygonAcrossRelayer.t.sol

.PHONY: test-redstone 
test-redstone:
	forge test --match-path test/multichain-setup/RedstoneAcrossRelayer.t.sol

.PHONY: test-scroll 
test-scroll:
	forge test --match-path test/multichain-setup/ScrollAcrossRelayer.t.sol

.PHONY: test-zksync 
test-zksync:
	forge test --match-path test/multichain-setup/ZkSyncAcrossRelayer.t.sol

.PHONY: test-zora 
test-zora:
	forge test --match-path test/multichain-setup/ZoraAcrossRelayer.t.sol

.PHONY: test-all
test-all:
	./sh-script/test-all.sh

	