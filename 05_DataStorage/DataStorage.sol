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

    function fCalldata(uint[] calldata _x) public pure returns(uint[] calldata){
        //参数为calldata数组，不能被修改
        //_x[0] = 0;  //这样会编译报错
        return(_x);
    }

}

contract Variables {
    uint public x = 1;
    uint public y;
    string public z;

    // 状态变量, gas消耗高
    function foo() external {
        //可以在函数中更改状态变量的值
        x=5;
        y=2;
        z="0xAA";
    }

    // 局部变量, gas消耗低
    function bar() external pure returns(uint){
        uint xx = 1;
        uint yy = 3;
        uint zz = xx + yy;
        return zz;
    }

    // 全局变量
    function global() external view returns(address, uint ,bytes memory){
        address sender = msg.sender;
        uint blockNum = block.number;
        bytes memory data = msg.data;
        return (sender, blockNum, data);
    }

    function weiUnit() external pure returns(uint){
        assert(1 wei == 1e0);
        assert(1 wei == 1);
        return 1 wei;
    }

    function gweiUnit() external pure returns(uint){
        assert(1 ether == 1e18);
        assert(1 ether == 1000000000000000000);
        return 1 ether;
    }

    function secondsUnit() external pure returns(uint){
        assert(1 seconds == 1);
        return 1 seconds;
    }


    function minutesUnit() external pure returns(uint){
        assert(1 minutes == 60);
        assert(1 minutes == 60 seconds);
        return 1 minutes;
    }

    function hoursUnit() external pure returns(uint){
        assert(1 hours == 3600);
        assert(1 hours == 60 minutes);
        return 1 hours;
    }

    function daysUnit() external pure returns(uint){
        assert(1 days == 86400);
        assert(1 days == 24 hours);
        return 1 days;
    }

    function weeksUnit() external pure returns(uint){
        assert(1 weeks == 604800);
        assert(1 weeks == 7 days);
        return 1 weeks;
    }

    /**
    重点：数据位置
    整体gas从多到少依次为：
    1. storage: 合约里的状态变量默认都是storage，存储在链上
    2. memory: 函数里面的参数和临时变量一般用memory, 存储在内存中，不上链。尤其是如果返回数据类型是变长的情况下，必须加memory修饰
    例如：string, bytes, array 和自定义结构。
    3. calldata: 和memory类似，存储在内存中，不上链，与memory的不同点在于calldata变量不能修改(immutable), 一般用于函数的参数。


    */


}