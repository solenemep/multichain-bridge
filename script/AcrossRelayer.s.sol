// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {ProxyAdmin} from "lib/openzeppelin-contracts/contracts/proxy/transparent/ProxyAdmin.sol";
import {TransparentUpgradeableProxy as Proxy} from "lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import "src/AcrossRelayer.sol";

import {Script, console} from "lib/forge-std/src/Script.sol";

contract AcrossRelayerScript is Script {
    uint256 public chainId;

    ProxyAdmin public proxyAdmin;
    AcrossRelayer public acrossRelayer;

    address public owner;

    address public spokePoolAddress;

    address public feeReceiver;
    uint256 public feePercent;

    function _setUp(
        uint256 _chainId,
        address _owner,
        address _spokePoolAddress,
        address _feeReceiver
    ) internal {
        chainId = _chainId;

        owner = _owner;

        spokePoolAddress = _spokePoolAddress;

        feeReceiver = _feeReceiver;
        feePercent = 2e5; // 0.2%
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Deployment on chain :", chainId);

        proxyAdmin = new ProxyAdmin(owner);

        Proxy acrossRelayerProxy = new Proxy(
            address(new AcrossRelayer()),
            address(proxyAdmin),
            abi.encodeWithSignature(
                "initialize(address,address,address,uint256)",
                owner,
                spokePoolAddress,
                feeReceiver,
                feePercent
            )
        );
        acrossRelayer = AcrossRelayer(address(acrossRelayerProxy));

        console.log("AcrossRelayer at :", address(acrossRelayer));

        vm.stopBroadcast();
    }
}
