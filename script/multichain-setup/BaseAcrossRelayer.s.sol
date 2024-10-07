// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract BaseAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("BASE_CHAIN_ID"),
            vm.envAddress("BASE_OWNER"),
            vm.envAddress("BASE_SPOKE_POOL"),
            vm.envAddress("BASE_FEE_RECEIVER")
        );
    }
}
