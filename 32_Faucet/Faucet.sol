// SPDX-License-Identifier: MIT
// WTF Solidity by 0xAA

pragma solidity ^0.8.21;

import "./IERC20.sol";

contract ERC20 is IERC20{

            
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    //代币总供给
    uint256 public override totalSupply;

    //名称
    string public name;

    //符号
    string public symbol;

    //小数位数
    uint8 public decimals = 18;


    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    function transfer(address to, uint256 amount) external returns (bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    //授权给代扣人
    function approve(address spender, uint256 amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //该方法调用者是代扣人
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool){
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // 铸造代币， 从`0` 地址转账给 调用者地址
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //销毁代币 从调用者地址转账给`0` 地址
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}



contract Faucet {

    //每次领取100单位代币
    uint256 public amountAllowed = 100;
    
    //token合约地址
    address public tokenContract; 
    
    //记录领取过代币的地址
    mapping(address => bool) public requestedAddress;

    event SendToken(address indexed Receiver, uint256 indexed Amount);

    //传入一个实现了IERC20接口的合约的地址
    constructor(address _tokenContract){
        tokenContract = _tokenContract;
    }

    //用户领取代币函数
    function requestTokens() external {
        require(!requestedAddress[msg.sender], "Can't Request Multiple Times");

        //类型转换， 转换后可以调用IERC20的函数
        IERC20 token = IERC20(tokenContract);

        require(token.balanceOf(address(this)) >= amountAllowed, "Faucet Empty!");

        //转账
        token.transfer(msg.sender, amountAllowed);

        //记录领取地址
        requestedAddress[msg.sender] = true;

        //释放SendToken事件
        emit SendToken(msg.sender, amountAllowed);

    }


}