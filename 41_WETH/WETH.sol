// SPDX-License-Identifier: MIT
// author: 0xAA
// original contract on ETH: https://rinkeby.etherscan.io/token/0xc778417e063141139fce010982780140aa0cd5ab?a=0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2#code
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20{
    //事件：存款和取款
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);

    constructor() ERC20("WETH", "WETH"){

    }

    fallback() external payable{
        deposit();
    }


    receive() external payable {        
        deposit(); 
    }

    //存款函数， 当用户存入ETH时，给他铸造等量的WTH
    function deposit() public payable  {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    //取款函数，用户销毁WETH时，取回等量的ETH
    function withdrawal(uint256 amount) public payable{
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }


}