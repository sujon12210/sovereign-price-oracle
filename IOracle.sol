// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IOracle {
    event PriceUpdated(uint256 price, uint256 timestamp);
    event ReporterAdded(address indexed reporter);
    
    function getLatestPrice() external view returns (uint256, uint256);
}
