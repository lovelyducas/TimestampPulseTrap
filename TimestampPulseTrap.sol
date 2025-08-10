// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract TimestampPulseTrap is ITrap {
    uint256 private constant THRESHOLD_SECONDS = 2; // Порог 2 секунды

    // collect возвращает timestamp текущего блока
    function collect() external view override returns (bytes memory) {
        return abi.encode(block.timestamp);
    }

    // shouldRespond сравнивает текущий и предыдущий timestamps, смотрит разницу
    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) {
            return (false, abi.encode("Not enough data"));
        }

        uint256 currentTimestamp = abi.decode(data[0], (uint256));
        uint256 previousTimestamp = abi.decode(data[1], (uint256));

        if (previousTimestamp == 0) {
            return (false, abi.encode("Invalid previous timestamp"));
        }

        uint256 diff = currentTimestamp > previousTimestamp
            ? currentTimestamp - previousTimestamp
            : previousTimestamp - currentTimestamp;

        if (diff >= THRESHOLD_SECONDS) {
            return (true, abi.encode("Timestamp pulse detected"));
        } else {
            return (false, abi.encode("No significant pulse"));
        }
    }
}
