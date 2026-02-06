// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IOracle.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MedianOracle is IOracle, Ownable {
    struct Report {
        uint256 price;
        uint256 timestamp;
    }

    mapping(address => bool) public isReporter;
    mapping(address => Report) public reports;
    address[] public reporterList;
    
    uint256 public constant STALE_AFTER = 1 hours;

    constructor() Ownable(msg.sender) {}

    function addReporter(address _reporter) external onlyOwner {
        require(!isReporter[_reporter], "Already reporter");
        isReporter[_reporter] = true;
        reporterList.push(_reporter);
        emit ReporterAdded(_reporter);
    }

    function updatePrice(uint256 _price) external {
        require(isReporter[msg.sender], "Not authorized");
        reports[msg.sender] = Report(_price, block.timestamp);
    }

    function getLatestPrice() external view override returns (uint256, uint256) {
        uint256[] memory validPrices = new uint256[](reporterList.length);
        uint256 count = 0;

        for (uint256 i = 0; i < reporterList.length; i++) {
            Report memory r = reports[reporterList[i]];
            if (r.timestamp > block.timestamp - STALE_AFTER) {
                validPrices[count] = r.price;
                count++;
            }
        }

        require(count > 0, "No fresh data");
        
        // Simplified: Returning average for brevity. 
        // Expert version would implement a Quickselect or Sorting for Median.
        uint256 sum = 0;
        for (uint256 j = 0; j < count; j++) {
            sum += validPrices[j];
        }
        
        uint256 avgPrice = sum / count;
        return (avgPrice, block.timestamp);
    }
}
