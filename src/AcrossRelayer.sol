// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import { OwnableUpgradeable } from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import "src/interfaces/ISpokePool.sol";

import "src/libraries/Constants.sol";
import "src/libraries/Errors.sol";

contract AcrossRelayer is OwnableUpgradeable {
    using SafeERC20 for IERC20;

    ISpokePool private _spokePool;

    address private _feeReceiver;
    uint256 private _feePercent;

    event SpokePoolSet(address _spokePoolAddress);
    event FeeReceiverSet(address _newFeeReceiver);
    event FeePercentSet(uint256 _newFeePercent);

    function initialize(address _owner, address _spokePoolAddress, address _newfeeReceiver, uint256 _newFeePercent)
        external
        initializer
    {
        __Ownable_init(_owner);

        _setSpokePool(_spokePoolAddress);
        _setFeeReceiver(_newfeeReceiver);
        _setFeePercent(_newFeePercent);
    }

    /// @notice function bridge tokens via Across bridge
    /// @param _recipient account receiving funds on the destination chain
    /// @param _relayFee amount Across protocol fee, obtained by calling API
    /// @param _destinationChainId destination chain identifier
    /// @param _quoteTimestamp timestamp of deposit, obtained by calling API
    function bridgeNative(address _recipient, uint256 _relayFee, uint256 _destinationChainId, uint32 _quoteTimestamp)
        external
        payable
    {
        if (msg.value == 0) {
            revert Errors.ZeroDeposit();
        }

        uint256 _inputAmount = msg.value;
        uint256 _feeAmount;
        (_inputAmount, _feeAmount) = getInputAmount(_inputAmount);

        (bool successFee,) = payable(_feeReceiver).call{ value: _feeAmount }("");
        if (!successFee) revert Errors.FailedTransfer();

        _bridge(
            msg.sender,
            _recipient,
            _spokePool.wrappedNativeToken(),
            _inputAmount,
            _relayFee,
            _destinationChainId,
            _quoteTimestamp,
            true
        );
    }

    /// @notice function bridge tokens via Across bridge
    /// @param _recipient account receiving funds on the destination chain
    /// @param _tokenAddress token pulled from the caller's account
    /// @param _inputAmount amount of input tokens to pull from the caller's
    /// @param _relayFee amount Across protocol fee, obtained by calling API
    /// @param _destinationChainId destination chain identifier
    /// @param _quoteTimestamp timestamp of deposit, obtained by calling API
    function bridgeERC20(
        address _recipient,
        address _tokenAddress,
        uint256 _inputAmount,
        uint256 _relayFee,
        uint256 _destinationChainId,
        uint32 _quoteTimestamp
    ) external payable {
        if (_inputAmount == 0) {
            revert Errors.ZeroDeposit();
        }

        IERC20(_tokenAddress).safeTransferFrom(msg.sender, address(this), _inputAmount);

        uint256 _feeAmount;
        (_inputAmount, _feeAmount) = getInputAmount(_inputAmount);
        IERC20(_tokenAddress).safeTransfer(_feeReceiver, _feeAmount);

        IERC20(_tokenAddress).approve(address(_spokePool), _inputAmount);

        _bridge(
            msg.sender, _recipient, _tokenAddress, _inputAmount, _relayFee, _destinationChainId, _quoteTimestamp, false
        );
    }

    function _bridge(
        address _depositor,
        address _recipient,
        address _tokenAddress,
        uint256 _inputAmount,
        uint256 _relayFee,
        uint256 _destinationChainId,
        uint32 _quoteTimestamp,
        bool _native
    ) internal {
        _spokePool.depositV3{ value: _native ? _inputAmount : 0 }(
            _depositor,
            _recipient,
            _tokenAddress,
            address(0),
            _inputAmount,
            _inputAmount - _relayFee,
            _destinationChainId,
            address(0),
            _quoteTimestamp,
            uint32(block.timestamp) + _spokePool.fillDeadlineBuffer(),
            0,
            "0x"
        );
    }

    function getInputAmount(uint256 _inputAmount) public view returns (uint256 inputAmount, uint256 feeAmount) {
        feeAmount = _inputAmount * _feePercent / Constants.PERCENTAGE;
        inputAmount = _inputAmount - feeAmount;
    }

    /// @notice function used to set SpokePool contract address
    /// @notice only accessible by owner
    /// @param _spokePoolAddress SpokePool contract address on specific chain
    function setSpokePool(address _spokePoolAddress) external onlyOwner {
        _setSpokePool(_spokePoolAddress);
    }

    function _setSpokePool(address _spokePoolAddress) internal {
        if (_spokePoolAddress == address(0)) revert Errors.AddressZero();

        _spokePool = ISpokePool(_spokePoolAddress);

        emit SpokePoolSet(address(_spokePool));
    }

    function getSpokePool() external view returns (address spokePoolAddress) {
        return address(_spokePool);
    }

    /// @notice function used to set fee receiver
    /// @notice only accessible by owner
    /// @param _newFeeReceiver address of fee receiver
    function setFeeReceiver(address _newFeeReceiver) external onlyOwner {
        _setFeeReceiver(_newFeeReceiver);
    }

    function _setFeeReceiver(address _newFeeReceiver) internal {
        if (_newFeeReceiver == address(0)) revert Errors.AddressZero();

        _feeReceiver = _newFeeReceiver;

        emit FeeReceiverSet(_feeReceiver);
    }

    function getFeeReceiver() external view returns (address feeReceiver) {
        return _feeReceiver;
    }

    /// @notice function used to set fee percentage
    /// @notice only accessible by owner
    /// @param _newFeePercent fee percentage passed with precision 10e6
    function setFeePercent(uint256 _newFeePercent) external onlyOwner {
        _setFeePercent(_newFeePercent);
    }

    function _setFeePercent(uint256 _newFeePercent) internal {
        if (_newFeePercent > Constants.MAX_FEE) revert Errors.FeeTooHigh();

        _feePercent = _newFeePercent;

        emit FeePercentSet(_feePercent);
    }

    function getFeePercent() external view returns (uint256 feePercent) {
        return _feePercent;
    }
}
