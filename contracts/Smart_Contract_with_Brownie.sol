/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract MyContract {

    uint256 myNumber;

    function getNumber() public view returns (uint) {
        return myNumber;
    }

    function changeNumber(uint _myNumber) public returns (uint) {
        myNumber = _myNumber;
        return myNumber;
    }
}
