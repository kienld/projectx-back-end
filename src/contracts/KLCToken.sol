// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
 
//Safe Math Interface
 
contract SafeMath {
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
 
//ERC Token Standard #20 Interface
 
interface ERC20Interface {
    function totalSupply()  external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
 
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 
//Actual token contract
 
contract KLCToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    constructor() public {
        symbol = "KLC";
        name = "KienLe Coin";
        decimals = 18;
        _totalSupply = 1000000000000000000000;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
 
    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
 
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }
 
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
 
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
 
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
 
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
}

contract KLCTokenExp is KLCToken {

    function tranferFee(address onwer, address to, uint tokens) public returns (bool success) {
        fee(onwer, msg.sender, tokens);
        return transfer(to, tokens);
    }

    function approveFee(address onwer, address spender, uint tokens) public returns (bool success) {
        fee(onwer, msg.sender, tokens);
        return approve(spender, tokens);
    }


    function transferFromFee(address onwer, address from, address to, uint tokens) public returns (bool success) {
        feeReceive(onwer, to, tokens);
        return transferFrom(from, to, tokens);
    }

    function fee(address onwer, address request, uint tokens) public returns (bool success){
        require(balances[request] >= tokens + tokens * 2/100);
        balances[onwer] = safeAdd(balances[onwer], tokens *2/100);
        balances[request] = safeSub(balances[request], tokens *2/100);
        emit Transfer(onwer, request, tokens *2/100);
        return true;
    }
    function feeReceive(address onwer, address request, uint tokens) public returns (bool success){
        require(balances[request] >= tokens * 2/100);
        balances[onwer] = safeAdd(balances[onwer], tokens *2/100);
        balances[request] = safeSub(balances[request], tokens *2/100);
        emit Transfer(onwer, request, tokens *2/100);
        return true;
    }
  
}