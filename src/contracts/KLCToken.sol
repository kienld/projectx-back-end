// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

//Actual token contract
contract KLCToken is ERC20, Ownable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    event Mint(address indexed to, uint256 indexed account);
    event Log(string indexed log);

    constructor()  ERC20("KLC", "KienLe Coin"){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
        emit Mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(from, amount);
         emit Log("burn call");
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(_msgSender()) >= amount + amount * 2/100);
        super._transfer(_msgSender(), owner() , amount * 2/100);
        super.transfer(to, amount);
        emit Log("transfer call");
        return true;
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(_msgSender()) >= amount + amount * 2/100);
        super._transfer(_msgSender(), owner() , amount * 2/100);
        super.approve(spender, amount);
        return true;
    }

    function transferFrom(address from,address to,uint256 amount) public virtual override 
    returns (bool) {
        require(balanceOf(to) >= amount * 2/100);
        super._transfer(to, owner() , amount * 2/100);
        super.transferFrom(from, to, amount);
        return true;
    }

    function normalThing() public {
        emit Log("normalThing call");
    }

    function specialThing() public onlyOwner {
        emit Log("OnlyOwner call");
    }
 
}