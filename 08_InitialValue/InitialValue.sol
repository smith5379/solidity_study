// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract InitialValue{
    //value type
    bool public _bool; 
    string public _string;
    int public _int;
    uint public _uint;
    address public _address;

    enum ActionSet{Buy,Hold, Sell}
    ActionSet public _enum;//第一个元素0

    function fi() internal{}
    function fe() external{}

    //引用类型
    uint[8] public _staticArray;
    uint[] public _dynamicArray;

    mapping(uint => address) public _mapping;

    //所有成员设为其默认值的结构体 0,0
    struct Student{
        uint256 id;
        uint256 score;
    }

    Student public student;

    //delete操作符，将变量的值还原为默认值
    bool public _bool2 = true;
    function d() external {
        delete _bool2;
    }

}
