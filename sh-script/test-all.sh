#set -e # Exit on error

source .env

forge test --match-path test/multichain-setup/ArbitrumAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/BaseAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/BlastAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/EthereumAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/LineaAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/LiskAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/ModeAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/OptimismAcrossRelayer.t.sol -vv 
forge test --match-path test/multichain-setup/PolygonAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/RedstoneAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/ScrollAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/ZkSyncAcrossRelayer.t.sol -vv
forge test --match-path test/multichain-setup/ZoraAcrossRelayer.t.sol -vv