// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract ScrollAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("SCROLL_CHAIN_ID"),
            vm.envAddress("SCROLL_OWNER"),
            vm.envAddress("SCROLL_SPOKE_POOL"),
            vm.envAddress("SCROLL_FEE_RECEIVER")
        );
    }
}
