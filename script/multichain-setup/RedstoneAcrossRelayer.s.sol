// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract RedstoneAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("REDSTONE_CHAIN_ID"),
            vm.envAddress("REDSTONE_OWNER"),
            vm.envAddress("REDSTONE_SPOKE_POOL"),
            vm.envAddress("REDSTONE_FEE_RECEIVER")
        );
    }
}
