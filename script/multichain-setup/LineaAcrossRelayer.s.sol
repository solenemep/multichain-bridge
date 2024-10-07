// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract LineaAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("LINEA_CHAIN_ID"),
            vm.envAddress("LINEA_OWNER"),
            vm.envAddress("LINEA_SPOKE_POOL"),
            vm.envAddress("LINEA_FEE_RECEIVER")
        );
    }
}
