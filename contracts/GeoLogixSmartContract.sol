// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract GeoLogixSmartContract is ERC20, Ownable {
    address public employer;
    address public driver;
    uint256 public constant SALARY_AMOUNT = 0.15 ether;
    uint256 public constant REWARD_AMOUNT = 0.05 ether;
    uint256 public constant PENALIZE_AMOUNT = 0.05 ether;
    enum DriverPerformance { Excellent, Good, Average, BelowAverage, NotPerformed }
    mapping(address => DriverPerformance) public driverPerformances;
    event SalaryReleased(address indexed driver, uint256 amount);
    event RewardReleased(address indexed driver, uint256 amount);
    event PenaltyApplied(address indexed driver, uint256 amount);
    constructor()Ownable()ERC20("GeoLogixToken", "GLT") {
        employer = payable(0x126bF9bCd4D69BDb0726e00e76299F95b03a11b2);
        driver = payable(0x0C6342C070Ca9A5699B5F7bfaEE5B5953d0C851c);
    }
    function evaluateDriver(
        int256 currentLatitude,
        int256 currentLongitude
    ) external onlyOwner {
        // require(timestamp == 20 minutes, "Invalid timestamp");
        // Check if the driver is at the checkpoint
        // we have the one checkpoints (100,100) 
        if (((uint256(100-currentLatitude))<=5 && (uint256(100-currentLongitude))<=5 )) {
            payable(driver).transfer(SALARY_AMOUNT + REWARD_AMOUNT);
        }
        else if ((uint256(100-currentLatitude)<=10 && uint256(100-currentLongitude)<=10)) {
            payable(driver).transfer(SALARY_AMOUNT);
        }
        else {
            payable(driver).transfer(SALARY_AMOUNT-PENALIZE_AMOUNT);
        }
    }
}