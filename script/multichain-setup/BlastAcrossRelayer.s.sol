// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { AcrossRelayerScript } from "script/AcrossRelayer.s.sol";

import "src/AcrossRelayer.sol";

contract BlastAcrossRelayerScript is AcrossRelayerScript {
    function setUp() public {
        _setUp(
            vm.envUint("BLAST_CHAIN_ID"),
            vm.envAddress("BLAST_OWNER"),
            vm.envAddress("BLAST_SPOKE_POOL"),
            vm.envAddress("BLAST_FEE_RECEIVER")
        );
    }
}
