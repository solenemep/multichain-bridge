// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerTest } from "test/AcrossRelayer.t.sol";

import "src/AcrossRelayer.sol";

contract ModeAcrossRelayerTest is AcrossRelayerTest {
    function setUp() public {
        _setUp(
            vm.envString("MODE_RPC_URL"),
            [
                vm.envUint("ARBITRUM_CHAIN_ID"),
                vm.envUint("BASE_CHAIN_ID"),
                vm.envUint("BLAST_CHAIN_ID"),
                vm.envUint("ETHEREUM_CHAIN_ID"),
                vm.envUint("LINEA_CHAIN_ID"),
                vm.envUint("LISK_CHAIN_ID"),
                vm.envUint("OPTIMISM_CHAIN_ID"),
                vm.envUint("POLYGON_CHAIN_ID"),
                vm.envUint("REDSTONE_CHAIN_ID"),
                vm.envUint("SCROLL_CHAIN_ID"),
                vm.envUint("ZKSYNC_CHAIN_ID"),
                vm.envUint("ZORA_CHAIN_ID")
            ],
            vm.envAddress("MODE_SPOKE_POOL"),
            vm.envAddress("MODE_TKN")
        );
    }
}
