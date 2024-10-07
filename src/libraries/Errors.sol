// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

library Errors {
    // Global
    error AddressZero();

    // AcrossRelayer
    error ZeroDeposit();
    error FailedTransfer();
    error FeeTooHigh();
}
