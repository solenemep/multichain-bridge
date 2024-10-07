// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract LiskAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("LISK_CHAIN_ID"),
            vm.envAddress("LISK_OWNER"),
            vm.envAddress("LISK_SPOKE_POOL"),
            vm.envAddress("LISK_FEE_RECEIVER")
        );
    }
}
