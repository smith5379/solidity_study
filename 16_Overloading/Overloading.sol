// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Overload{
    function saySomething() public pure returns(string memory){
        return "Nothing";
    }

    function saySomething(string memory param) public pure returns(string memory){
        return param;
    }




    //下面这两个方法在0.7.x版本中,会报错,原因是因为0.7.x引用了更严格的字面量类型推断, 整数字面量默认为uint256.
    // 而在0.7.x之前的版本中, 字面量能匹配多个类型(取决于具体的上下文)
    function f(uint8 param) public pure returns(uint8){
        return param;
    }

    function f(uint256 param) public pure returns(uint256){
        return param;
    }


}