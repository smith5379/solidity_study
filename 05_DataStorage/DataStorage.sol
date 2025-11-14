// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DataStorage {
    //默认存储类型是storage
    uint[] public x = [1, 2, 3];

    function fStorage() public {
        // 声明一个storage的变量xStorage, 指向x, 修改xStorage也会影响x
        uint[] storage xStorage = x;
        xStorage[0] = 100;
    }

    function fMemory() public view{
        // 声明一个memory的变量xMemory, 复制x, 修改xMemory不会影响x
        uint[] memory xMemory = x;
        xMemory[0] = 100;
        xMemory[1] = 200;
        uint[] memory xMemory2 = x;
        xMemory2[0] = 300;
    }



}