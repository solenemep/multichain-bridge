// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { ProxyAdmin } from "lib/openzeppelin-contracts/contracts/proxy/transparent/ProxyAdmin.sol";
import { TransparentUpgradeableProxy as Proxy } from
    "lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { ERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import "src/AcrossRelayer.sol";
import "src/mock/EmptyMock.sol";

import "test/interfaces/ISpokePoolTest.sol";

import { Test, console } from "lib/forge-std/src/Test.sol";

contract AcrossRelayerTest is Test {
    ProxyAdmin public proxyAdmin;
    AcrossRelayer public acrossRelayer;

    address public owner;
    address public user;

    address public spokePoolAddress;
    address public wntAddress;
    address public tokenAddress;

    address public feeReceiver;
    uint256 public feePercent;

    uint256 public wntAmount;
    uint256 public tokenAmount;

    uint256[12] public chainIds;

    uint256 public relayFee = 1;

    event SpokePoolSet(address _spokePoolAddress);
    event FeeReceiverSet(address _newFeeReceiver);
    event FeePercentSet(uint256 _newFeePercent);

    function _setUp(string memory _rpc, uint256[12] memory _chainIds, address _spokePoolAddress, address _tokenAddress)
        internal
    {
        vm.createSelectFork(_rpc);
        chainIds = _chainIds;

        owner = makeAddr("Owner");
        user = makeAddr("User");

        spokePoolAddress = _spokePoolAddress;
        wntAddress = ISpokePool(_spokePoolAddress).wrappedNativeToken();
        tokenAddress = _tokenAddress;

        feeReceiver = makeAddr("FeeReceiver");
        feePercent = 2e5; // 0.2%

        proxyAdmin = new ProxyAdmin(owner);

        Proxy acrossRelayerProxy = new Proxy(
            address(new AcrossRelayer()),
            address(proxyAdmin),
            abi.encodeWithSignature(
                "initialize(address,address,address,uint256)", owner, spokePoolAddress, feeReceiver, feePercent
            )
        );
        acrossRelayer = AcrossRelayer(address(acrossRelayerProxy));

        uint8 wntDecimals = ERC20(wntAddress).decimals();
        wntAmount = 100 * 10 ** wntDecimals;

        deal(user, wntAmount);
        assertEq(user.balance, wntAmount);

        uint8 tokenDecimals = ERC20(tokenAddress).decimals();
        tokenAmount = 100 * 10 ** tokenDecimals;

        deal(tokenAddress, user, tokenAmount);
        assertEq(IERC20(tokenAddress).balanceOf(user), tokenAmount);
    }

    // initialize
    function test_initialize_FAIL_OwnableInvalidOwner() public {
        address acrossRelayerImpl = address(new AcrossRelayer());

        vm.expectRevert();
        new Proxy(
            acrossRelayerImpl,
            address(proxyAdmin),
            abi.encodeWithSignature(
                "initialize(address,address,address,uint256)", address(0), spokePoolAddress, feeReceiver, feePercent
            )
        );
    }

    function test_initialize_FAIL_AddressZero() public {
        address acrossRelayerImpl = address(new AcrossRelayer());

        vm.expectRevert(Errors.AddressZero.selector);
        new Proxy(
            acrossRelayerImpl,
            address(proxyAdmin),
            abi.encodeWithSignature(
                "initialize(address,address,address,uint256)", owner, address(0), feeReceiver, feePercent
            )
        );

        vm.expectRevert(Errors.AddressZero.selector);
        new Proxy(
            acrossRelayerImpl,
            address(proxyAdmin),
            abi.encodeWithSignature(
                "initialize(address,address,address,uint256)", owner, spokePoolAddress, address(0), feePercent
            )
        );
    }

    function test_initialize_FAIL_FeeTooHigh() public {
        address acrossRelayerImpl = address(new AcrossRelayer());

        vm.expectRevert(Errors.FeeTooHigh.selector);
        new Proxy(
            acrossRelayerImpl,
            address(proxyAdmin),
            abi.encodeWithSignature(
                "initialize(address,address,address,uint256)", owner, spokePoolAddress, feeReceiver, 60e6
            )
        );
    }

    function test_initialize_PASS() public {
        Proxy acrossRelayerProxy = new Proxy(
            address(new AcrossRelayer()),
            address(proxyAdmin),
            abi.encodeWithSignature(
                "initialize(address,address,address,uint256)", owner, spokePoolAddress, feeReceiver, feePercent
            )
        );
        AcrossRelayer acrossRelayerLocal = AcrossRelayer(address(acrossRelayerProxy));

        assertEq(address(acrossRelayerLocal.owner()), owner);
        assertEq(address(acrossRelayerLocal.getSpokePool()), spokePoolAddress);
        assertEq(acrossRelayerLocal.getFeeReceiver(), feeReceiver);
        assertEq(acrossRelayerLocal.getFeePercent(), feePercent);
    }

    // bridge
    function test_bridgeNative_FAIL_ZeroDeposit(uint256 destinationChainId) public {
        vm.assume(_checkDestinationChainIdNative(destinationChainId));

        address depositor = user;
        address recipient = user;

        uint256 balanceDBefore = depositor.balance;
        uint256 balanceFRBefore = feeReceiver.balance;
        uint256 balanceARBefore = address(acrossRelayer).balance;

        vm.startPrank(depositor);
        vm.expectRevert(Errors.ZeroDeposit.selector);
        acrossRelayer.bridgeNative{ value: 0 }(recipient, relayFee, destinationChainId, uint32(block.timestamp) - 36);
        vm.stopPrank();

        uint256 balanceDAfter = depositor.balance;
        uint256 balanceFRAfter = feeReceiver.balance;
        uint256 balanceARAfter = address(acrossRelayer).balance;

        assertEq(balanceDBefore - balanceDAfter, 0);
        assertEq(balanceFRAfter - balanceFRBefore, 0);
        assertEq(balanceARBefore, balanceARAfter);
    }

    function test_bridgeNative_PASS(uint256 destinationChainId) public {
        vm.assume(_checkDestinationChainIdNative(destinationChainId));

        address depositor = user;
        address recipient = user;

        (, uint256 feeAmount) = acrossRelayer.getInputAmount(wntAmount);

        uint256 balanceDBefore = depositor.balance;
        uint256 balanceFRBefore = feeReceiver.balance;
        uint256 balanceARBefore = address(acrossRelayer).balance;

        vm.prank(depositor);
        acrossRelayer.bridgeNative{ value: wntAmount }(
            recipient, relayFee, destinationChainId, uint32(block.timestamp) - 36
        );

        uint256 balanceDAfter = depositor.balance;
        uint256 balanceFRAfter = feeReceiver.balance;
        uint256 balanceARAfter = address(acrossRelayer).balance;

        assertEq(balanceDBefore - balanceDAfter, wntAmount);
        assertEq(balanceFRAfter - balanceFRBefore, feeAmount);
        assertEq(balanceARBefore, balanceARAfter);
    }

    function test_bridgeERC20_FAIL_ZeroDeposit(uint256 destinationChainId) public {
        vm.assume(_checkDestinationChainIdERC20(destinationChainId));

        address depositor = user;
        address recipient = user;

        uint256 balanceDBefore = IERC20(tokenAddress).balanceOf(depositor);
        uint256 balanceFRBefore = IERC20(tokenAddress).balanceOf(feeReceiver);
        uint256 balanceARBefore = IERC20(tokenAddress).balanceOf(address(acrossRelayer));

        vm.startPrank(depositor);
        IERC20(tokenAddress).approve(address(acrossRelayer), tokenAmount);

        vm.expectRevert(Errors.ZeroDeposit.selector);
        acrossRelayer.bridgeERC20(
            recipient, tokenAddress, 0, relayFee, destinationChainId, uint32(block.timestamp) - 36
        );
        vm.stopPrank();

        uint256 balanceDAfter = IERC20(tokenAddress).balanceOf(depositor);
        uint256 balanceFRAfter = IERC20(tokenAddress).balanceOf(feeReceiver);
        uint256 balanceARAfter = IERC20(tokenAddress).balanceOf(address(acrossRelayer));

        assertEq(balanceDBefore - balanceDAfter, 0);
        assertEq(balanceFRAfter - balanceFRBefore, 0);
        assertEq(balanceARBefore, balanceARAfter);
    }

    function test_bridgeERC20_PASS(uint256 destinationChainId) public {
        vm.assume(_checkDestinationChainIdERC20(destinationChainId));

        address depositor = user;
        address recipient = user;

        (, uint256 feeAmount) = acrossRelayer.getInputAmount(tokenAmount);

        uint256 balanceDBefore = IERC20(tokenAddress).balanceOf(depositor);
        uint256 balanceFRBefore = IERC20(tokenAddress).balanceOf(feeReceiver);
        uint256 balanceARBefore = IERC20(tokenAddress).balanceOf(address(acrossRelayer));

        vm.startPrank(depositor);
        IERC20(tokenAddress).approve(address(acrossRelayer), tokenAmount);

        acrossRelayer.bridgeERC20(
            recipient, tokenAddress, tokenAmount, relayFee, destinationChainId, uint32(block.timestamp) - 36
        );
        vm.stopPrank();

        uint256 balanceDAfter = IERC20(tokenAddress).balanceOf(depositor);
        uint256 balanceFRAfter = IERC20(tokenAddress).balanceOf(feeReceiver);
        uint256 balanceARAfter = IERC20(tokenAddress).balanceOf(address(acrossRelayer));

        assertEq(balanceDBefore - balanceDAfter, tokenAmount);
        assertEq(balanceFRAfter - balanceFRBefore, feeAmount);
        assertEq(balanceARBefore, balanceARAfter);
    }

    // setSpokePool
    function test_setSpokePool_FAIL_OwnableUnauthorizedAccount() public {
        address spokePoolBefore = address(acrossRelayer.getSpokePool());
        address newSpokePool = address(new EmptyMock());

        vm.startPrank(user);
        vm.expectRevert();
        acrossRelayer.setSpokePool(newSpokePool);
        vm.stopPrank();

        address spokePoolAfter = address(acrossRelayer.getSpokePool());
        assertEq(spokePoolBefore, spokePoolAfter);
    }

    function test_setSpokePool_FAIL_AddressZero() public {
        address spokePoolBefore = address(acrossRelayer.getSpokePool());
        address newSpokePool = address(0);

        vm.startPrank(owner);
        vm.expectRevert(Errors.AddressZero.selector);
        acrossRelayer.setSpokePool(newSpokePool);
        vm.stopPrank();

        address spokePoolAfter = address(acrossRelayer.getSpokePool());
        assertEq(spokePoolBefore, spokePoolAfter);
    }

    function test_setSpokePool_PASS() public {
        address spokePoolBefore = address(acrossRelayer.getSpokePool());
        address newSpokePool = address(new EmptyMock());

        vm.prank(owner);
        acrossRelayer.setSpokePool(newSpokePool);

        address spokePoolAfter = address(acrossRelayer.getSpokePool());
        assertNotEq(spokePoolBefore, spokePoolAfter);
        assertEq(spokePoolAfter, newSpokePool);
    }

    function test_setSpokePool_EVENT_SpokePoolSet() public {
        address newSpokePool = address(new EmptyMock());

        vm.startPrank(owner);
        vm.expectEmit(address(acrossRelayer));
        emit SpokePoolSet(newSpokePool);
        acrossRelayer.setSpokePool(newSpokePool);
        vm.stopPrank();
    }

    // setFeeReceiver
    function test_setFeeReceiver_FAIL_OwnableUnauthorizedAccount() public {
        address feeReceiverBefore = address(acrossRelayer.getFeeReceiver());
        address newFeeReceiver = address(new EmptyMock());

        vm.startPrank(user);
        vm.expectRevert();
        acrossRelayer.setFeeReceiver(newFeeReceiver);
        vm.stopPrank();

        address feeReceiverAfter = address(acrossRelayer.getFeeReceiver());
        assertEq(feeReceiverBefore, feeReceiverAfter);
    }

    function test_setFeeReceiver_FAIL_AddressZero() public {
        address feeReceiverBefore = address(acrossRelayer.getFeeReceiver());
        address newFeeReceiver = address(0);

        vm.startPrank(owner);
        vm.expectRevert(Errors.AddressZero.selector);
        acrossRelayer.setFeeReceiver(newFeeReceiver);
        vm.stopPrank();

        address feeReceiverAfter = address(acrossRelayer.getFeeReceiver());
        assertEq(feeReceiverBefore, feeReceiverAfter);
    }

    function test_setFeeReceiver_PASS() public {
        address feeReceiverBefore = address(acrossRelayer.getFeeReceiver());
        address newFeeReceiver = address(new EmptyMock());

        vm.prank(owner);
        acrossRelayer.setFeeReceiver(newFeeReceiver);

        address feeReceiverAfter = address(acrossRelayer.getFeeReceiver());
        assertNotEq(feeReceiverBefore, feeReceiverAfter);
        assertEq(feeReceiverAfter, newFeeReceiver);
    }

    function test_setFeeReceiver_EVENT_SpokePoolSet() public {
        address newFeeReceiver = address(new EmptyMock());

        vm.startPrank(owner);
        vm.expectEmit(address(acrossRelayer));
        emit FeeReceiverSet(newFeeReceiver);
        acrossRelayer.setFeeReceiver(newFeeReceiver);
        vm.stopPrank();
    }

    // setFeePercent
    function test_setFeePercent_FAIL_OwnableUnauthorizedAccount() public {
        uint256 feePercentBefore = acrossRelayer.getFeePercent();
        uint256 newFeePercent = 10e6;

        vm.startPrank(user);
        vm.expectRevert();
        acrossRelayer.setFeePercent(newFeePercent);
        vm.stopPrank();

        uint256 feePercentAfter = acrossRelayer.getFeePercent();
        assertEq(feePercentBefore, feePercentAfter);
    }

    function test_setFeePercent_FAIL_FeeTooHigh() public {
        uint256 feePercentBefore = acrossRelayer.getFeePercent();
        uint256 newFeePercent = 6e6;

        vm.startPrank(owner);
        vm.expectRevert(Errors.FeeTooHigh.selector);
        acrossRelayer.setFeePercent(newFeePercent);
        vm.stopPrank();

        uint256 feePercentAfter = acrossRelayer.getFeePercent();
        assertEq(feePercentBefore, feePercentAfter);
    }

    function test_setFeePercent_PASS() public {
        uint256 feePercentBefore = acrossRelayer.getFeePercent();
        uint256 newFeePercent = 1e5;

        vm.prank(owner);
        acrossRelayer.setFeePercent(newFeePercent);

        uint256 feePercentAfter = acrossRelayer.getFeePercent();
        assertNotEq(feePercentBefore, feePercentAfter);
        assertEq(feePercentAfter, newFeePercent);
    }

    function test_setFeePercent_EVENT_FeePercentSet() public {
        uint256 newFeePercent = 1e5;

        vm.startPrank(owner);
        vm.expectEmit(address(acrossRelayer));
        emit FeePercentSet(newFeePercent);
        acrossRelayer.setFeePercent(newFeePercent);
        vm.stopPrank();
    }

    // utils
    function _checkDestinationChainIdNative(uint256 destinationChainId) internal view returns (bool check) {
        for (uint256 i = 0; i < 12;) {
            if (
                chainIds[i] == destinationChainId
                    && ISpokePoolTest(spokePoolAddress).enabledDepositRoutes(wntAddress, destinationChainId)
            ) {
                return true;
            }
            unchecked {
                i++;
            }
        }
    }

    function _checkDestinationChainIdERC20(uint256 destinationChainId) internal view returns (bool check) {
        for (uint256 i = 0; i < 12;) {
            if (
                chainIds[i] == destinationChainId
                    && ISpokePoolTest(spokePoolAddress).enabledDepositRoutes(tokenAddress, destinationChainId)
            ) {
                return true;
            }
            unchecked {
                i++;
            }
        }
    }
}
