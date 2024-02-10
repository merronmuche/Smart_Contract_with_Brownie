// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract GeoLogixSmartContract is ERC20, Ownable{
    uint256 public constant SALARY_AMOUNT = 0.1 ether;
    uint256 public constant REWARD_AMOUNT = 0.05 ether;

    enum DriverPerformance { Excellent, Good, Average, BelowAverage, NotPerformed }

    mapping(address => DriverPerformance) public driverPerformances;

    event SalaryReleased(address indexed driver, uint256 amount);
    event RewardReleased(address indexed driver, uint256 amount);
    event PenaltyApplied(address indexed driver, uint256 amount);
    event FundsSent(address indexed sender, address indexed receiver, uint256 amount);

    constructor() ERC20("GeoLogixToken", "GLT") {
    }

    function evaluateDriver(
        address driver,
        uint256 timestamp,
        int256 latitude,
        int256 longitude,
        int256 expectedLatitude,
        int256 expectedLongitude
    ) external onlyOwner {
        DriverPerformance performance = calculatePerformance(timestamp, latitude, longitude, expectedLatitude, expectedLongitude);
        _releaseFunds(driver, SALARY_AMOUNT + REWARD_AMOUNT);
        if (performance == DriverPerformance.Excellent) {
            _releaseFunds(driver, SALARY_AMOUNT + REWARD_AMOUNT);
        } else if (performance == DriverPerformance.Good) {
            _releaseFunds(driver, SALARY_AMOUNT);
            _returnFunds(owner(), REWARD_AMOUNT);
        } else if (performance == DriverPerformance.Average) {
            _releaseFunds(driver, SALARY_AMOUNT - 0.05 ether);
            _returnFunds(owner(), 0.05 ether);
            emit PenaltyApplied(driver, 0.05 ether);
        } else if (performance == DriverPerformance.BelowAverage) {
            _releaseFunds(driver, SALARY_AMOUNT - 0.07 ether);
            _returnFunds(owner(), 0.07 ether);
            emit PenaltyApplied(driver, 0.07 ether);
        } else {
            emit PenaltyApplied(driver, SALARY_AMOUNT + REWARD_AMOUNT);
        }
        driverPerformances[driver] = performance;

    }

    function sendFunds(address driver, uint256 amount) external onlyOwner {
        require(amount <= 0.05 ether, "Amount should be 0.05 ether or less");
        _transfer(owner(), driver, amount);
        emit FundsSent(owner(), driver, amount);
    }

    function calculatePerformance(
        uint256 timestamp,
        int256 latitude,
        int256 longitude,
        int256 expectedLatitude,
        int256 expectedLongitude
    ) internal pure returns (DriverPerformance) {
       
        uint256 closeness = calculateCloseness(latitude, longitude, expectedLatitude, expectedLongitude);

        if (closeness > 90) {
            return DriverPerformance.Excellent;
        } else if (closeness > 75) {
            return DriverPerformance.Good;
        } else if (closeness > 50) {
            return DriverPerformance.Average;
        } else if (closeness > 25) {
            return DriverPerformance.BelowAverage;
        } else {
            return DriverPerformance.NotPerformed;
        }
    }

    function calculateCloseness(
        int256 latitude,
        int256 longitude,
        int256 expectedLatitude,
        int256 expectedLongitude
    ) internal pure returns (uint256) {
        
        uint256 distance = calculateDistance(latitude, longitude, expectedLatitude, expectedLongitude);
        uint256 maxDistance = 100; 
        return (maxDistance - distance) * 100 / maxDistance;
    }

    function calculateDistance(
        int256 lat1,
        int256 lon1,
        int256 lat2,
        int256 lon2
    ) internal pure returns (uint256) {
        
        int256 latDiff = lat1 - lat2;
        int256 lonDiff = lon1 - lon2;
        return uint256((latDiff * latDiff + lonDiff * lonDiff));
    }

    function _releaseFunds(address to, uint256 amount) internal {
        _transfer(owner(), to, amount);
        if (amount > 0) {
            emit SalaryReleased(to, amount);
        }
    }

    function _returnFunds(address to, uint256 amount) internal {
        _transfer(owner(), to, amount);
        if (amount > 0) {
            emit RewardReleased(to, amount);
        }
    }
}}
