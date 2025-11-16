// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Mapping{
    mapping(uint => address) public idToAddress; //id映射到地址
    mapping(address => address) public swapPair; //币对的映射，地址到地址


    //key的类型不能是自定义的结构体

    function writeMap(uint _Key, address _Value) public {
        idToAddress[_Key] = _Value;
    }

}