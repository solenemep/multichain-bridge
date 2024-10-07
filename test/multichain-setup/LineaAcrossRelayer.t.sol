// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerTest } from "test/AcrossRelayer.t.sol";

import "src/AcrossRelayer.sol";

contract LineaAcrossRelayerTest is AcrossRelayerTest {
    function setUp() public {
        _setUp(
            vm.envString("LINEA_RPC_URL"),
            [
                vm.envUint("ARBITRUM_CHAIN_ID"),
                vm.envUint("BASE_CHAIN_ID"),
                vm.envUint("BLAST_CHAIN_ID"),
                vm.envUint("ETHEREUM_CHAIN_ID"),
                vm.envUint("LISK_CHAIN_ID"),
                vm.envUint("MODE_CHAIN_ID"),
                vm.envUint("OPTIMISM_CHAIN_ID"),
                vm.envUint("POLYGON_CHAIN_ID"),
                vm.envUint("REDSTONE_CHAIN_ID"),
                vm.envUint("SCROLL_CHAIN_ID"),
                vm.envUint("ZKSYNC_CHAIN_ID"),
                vm.envUint("ZORA_CHAIN_ID")
            ],
            vm.envAddress("LINEA_SPOKE_POOL"),
            vm.envAddress("LINEA_TKN")
        );
    }
}
