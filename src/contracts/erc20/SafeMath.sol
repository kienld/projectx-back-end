// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Safe Math
contract SafeMath {
    function safeAdd(uint256 a, uint256 b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint256 a, uint256 b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint256 a, uint256 b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint256 a, uint256 b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}