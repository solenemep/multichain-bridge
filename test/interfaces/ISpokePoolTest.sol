// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

interface ISpokePoolTest {
    function enabledDepositRoutes(address tokenAddress, uint256 chainId) external view returns (bool);
}
