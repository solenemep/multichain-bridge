// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

interface ISpokePool {
    function wrappedNativeToken() external returns (address);

    function fillDeadlineBuffer() external returns (uint32);

    function depositV3(
        address depositor,
        address recipient,
        address inputToken,
        address outputToken,
        uint256 inputAmount,
        uint256 outputAmount,
        uint256 destinationChainId,
        address exclusiveRelayer,
        uint32 quoteTimestamp,
        uint32 fillDeadline,
        uint32 exclusivityDeadline,
        bytes calldata message
    ) external payable;
}
