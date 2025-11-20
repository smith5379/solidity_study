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


// 想多个地址转账代币或ETH
contract AirDrop {
    mapping(address => uint) failTransferList;

    function multiTransferToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts
    )external {
        //检查：_addresses和_amounts数组长度相等
        require(
            _addresses.length == _amounts.length,
            "Lengths of Addresses and Amounts Not Equal"
        );
        IERC20 token = IERC20(_token);
        //计算需要空投的总代币数量
        uint _amountSum = getSum(_amounts);

        //检查 授权代币数量是否大于等于需要空投的总代币数量
        require(
            token.allowance(msg.sender, address(this)) >= _amountSum,
            "Need Approve ERC token"
                    );

        //for循环, 利用transferFrom 函数发送空投
        for(uint256 i; i < _addresses.length; i++){
            token.transferFrom(msg.sender, _addresses[i], _amounts[i]);
        }
    }


    function multiTransferETH(
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable {
        //检查：_addresses和_amounts数组长度相等
        require(
            _addresses.length == _amounts.length,
            "Lengths of Addresses and Amounts Not Equal"
        );
        //计算需要空投的总ETH数量
        uint _amountSum = getSum(_amounts);

        //检查转入ETH等于空投总量
        require(
            msg.value == _amountSum, "Transfer amount error");

        //for循环, 利用transferFrom 函数发送空投
        for(uint256 i; i < _addresses.length; i++){

            (bool success, ) = _addresses[i].call{value: _amounts[i]}("");
            if(!success){
                failTransferList[_addresses[i]] = _amounts[i];
            }
        }
    }


    // 给空投失败提供主动操作机会
    function withdrawFromFailList(address _to) public {
        uint failAmount = failTransferList[msg.sender];
        require(failAmount > 0, "You are not in failed list");
        failTransferList[msg.sender] = 0;
        (bool success, ) = _to.call{value: failAmount}("");
        require(success, "Fail withdraw");
    }


    function getSum(uint256[] calldata _arr) public pure returns(uint256 sum){
        for (uint256 i = 0; i< _arr.length; i++) sum = sum + _arr[i]; 
    }

}