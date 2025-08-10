// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimestampPulseRelay {
    event PulseDetected(string message);

    function relayPulse(bytes calldata data) external {
        string memory msgText = abi.decode(data, (string));
        emit PulseDetected(msgText);
    }
}
