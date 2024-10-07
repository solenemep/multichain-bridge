// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract PolygonAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("POLYGON_CHAIN_ID"),
            vm.envAddress("POLYGON_OWNER"),
            vm.envAddress("POLYGON_SPOKE_POOL"),
            vm.envAddress("POLYGON_FEE_RECEIVER")
        );
    }
}
