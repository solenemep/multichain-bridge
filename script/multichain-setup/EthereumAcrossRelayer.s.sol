// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract EthereumAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("ETHEREUM_CHAIN_ID"),
            vm.envAddress("ETHEREUM_OWNER"),
            vm.envAddress("ETHEREUM_SPOKE_POOL"),
            vm.envAddress("ETHEREUM_FEE_RECEIVER")
        );
    }
}
