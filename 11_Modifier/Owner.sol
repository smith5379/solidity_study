// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Owner{
    address public owner;

    constructor(address initialOwner){
        owner = initialOwner;
    }

    //定义修饰器
    modifier onlyOwner{
        require(msg.sender == owner); //检查调用者是否是owner地址(调用者就是deploy页面选择account的那个地址)
        _; //如果是的话， 继续运行函数主体，否则报错并revert交易
    }

    //定义一个带onlyOwner修饰符的函数
    function changeOwner(address _newOwner) external onlyOwner{
        owner = _newOwner; //只有owner地址可以运行这个函数, 并改变owner
    }


}
