// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorageNum {
    
    mapping(address => uint256) public num;

    function set(uint256 input) public {
        num[msg.sender] = input;
    }

    function get() public view returns (uint256) {
        return num[msg.sender];
    }
}