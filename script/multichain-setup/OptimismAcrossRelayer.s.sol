// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract OptimismAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("OPTIMISM_CHAIN_ID"),
            vm.envAddress("OPTIMISM_OWNER"),
            vm.envAddress("OPTIMISM_SPOKE_POOL"),
            vm.envAddress("OPTIMISM_FEE_RECEIVER")
        );
    }
}
