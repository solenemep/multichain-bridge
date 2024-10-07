// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract ZoraAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("ZORA_CHAIN_ID"),
            vm.envAddress("ZORA_OWNER"),
            vm.envAddress("ZORA_SPOKE_POOL"),
            vm.envAddress("ZORA_FEE_RECEIVER")
        );
    }
}
