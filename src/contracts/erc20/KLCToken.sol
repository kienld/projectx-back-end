// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ERC20Interface.sol";
import "./SafeMath.sol";

//Actual token contract
contract KLCToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint256 public _totalSupply;
    address private owner;
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
 
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
 
    constructor() {
        symbol = "KLC";
        name = "KienLe Coin";
        decimals = 18;
        _totalSupply = 1000000000000000000000;
        balances[msg.sender] = _totalSupply;
        owner = msg.sender;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
 
    function totalSupply() override public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
 
    function balanceOf(address tokenOwner) override public view returns (uint balance) {
        return balances[tokenOwner];
    }
 
    function transfer(address to, uint256 tokens) override public returns (bool success) {
        fee(msg.sender, tokens);
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
 
    function approve(address spender, uint256 tokens) override public returns (bool success) {
        fee(msg.sender, tokens);
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
 
    function transferFrom(address from, address to, uint256 tokens) override public returns (bool success) {
        feeReceive(to, tokens);
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
 
    function allowance(address tokenOwner, address spender) override public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function changeOwner(address newOwner) public {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function fee(address request, uint256 tokens) private returns (bool success){
        require(balances[request] >= tokens + tokens * 2/100);
        balances[owner] = safeAdd(balances[owner], tokens *2/100);
        balances[request] = safeSub(balances[request], tokens *2/100);
        emit Transfer(owner, request, tokens *2/100);
        return true;
    }
    function feeReceive(address request, uint256 tokens) private returns (bool success){
        require(balances[request] >= tokens * 2/100);
        balances[owner] = safeAdd(balances[owner], tokens *2/100);
        balances[request] = safeSub(balances[request], tokens *2/100);
        emit Transfer(owner, request, tokens *2/100);
        return true;
    }
 
}