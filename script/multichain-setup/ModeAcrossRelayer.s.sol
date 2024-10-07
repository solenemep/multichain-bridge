// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract ModeAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("MODE_CHAIN_ID"),
            vm.envAddress("MODE_OWNER"),
            vm.envAddress("MODE_SPOKE_POOL"),
            vm.envAddress("MODE_FEE_RECEIVER")
        );
    }
}
