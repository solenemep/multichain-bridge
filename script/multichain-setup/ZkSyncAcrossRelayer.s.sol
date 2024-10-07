// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract ZkSyncAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("ZKSYNC_CHAIN_ID"),
            vm.envAddress("ZKSYNC_OWNER"),
            vm.envAddress("ZKSYNC_SPOKE_POOL"),
            vm.envAddress("ZKSYNC_FEE_RECEIVER")
        );
    }
}
