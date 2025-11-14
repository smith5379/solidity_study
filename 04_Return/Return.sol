// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Return{

    //返回多个变量
    function returnMultiple() public pure returns(uint256, bool, uint256[3] memory){
        return(1, true, [uint256(1), 2, 5]);// [1,2,5] 默认是uint8数组, 需要将首个元素强转为指定类型
    }

    //命名式返回
    function returnNamed() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array){
        _number = 2;
        _bool = false;
        _array = [uint256(3), 2, 1];
    }

    //命名式返回 依然支持return
    function returnNamed2() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array){
        return (2,false, [uint256(3), uint256(2), 1]);
    }

    //解构式赋值

    function readReturn() public pure{
        //读取所有返回值
        uint256 _number;
        bool _bool;
        uint256[3] memory _array;
        (_number, _bool, _array) = returnNamed();

        //读取部分返回值
        (, _bool, ) = returnNamed2();
    }

    
    



}