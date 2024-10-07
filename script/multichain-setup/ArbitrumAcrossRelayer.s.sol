// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract ArbitrumAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("ARBITRUM_CHAIN_ID"),
            vm.envAddress("ARBITRUM_OWNER"),
            vm.envAddress("ARBITRUM_SPOKE_POOL"),
            vm.envAddress("ARBITRUM_FEE_RECEIVER")
        );
    }
}
