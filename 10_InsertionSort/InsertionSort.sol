// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract InsertionSort{

    // if else
    function ifElseTest(uint256 _number) public pure returns(bool){
        if(_number ==0){
            return true;
        }else{
            return false;
        }
    }

    function fooLoopTest() public pure returns(uint256){
        uint sum =0;
        for(uint i = 0; i< 10; i++){
            sum +=i;
        }
        return sum;
    }


    function whileTest() public pure returns(uint256){
        uint sum =0;
        uint i = 0;
        while(i< 10){
            sum +=i;
            i++;
        }
        return(sum);
    }


    function doWhileTest() public pure returns(uint256){
        uint sum = 0;
        uint i =0;
        while(i<10){
            sum +=i;
            i++;
        }
        return sum;
    }

    function ternaryTest(uint256 x, uint256 y) public pure returns(uint256){
        return x>=y ? x: y;
    }





    // 错误版本，由于uint不可能小于0,当j=0, j--后，j是一个最大的int值，此时arr[j] 下标越界
    function insertSort(uint[] memory arr) pure public returns( uint[] memory){
        for (uint i = 1; i < arr.length; i++) {
            uint current = arr[i];
            uint j = i - 1;

            while (j >= 0 && arr[j] > current) {
                arr[j+1] = arr[j];
                j--;
            }
            arr[j+1] = current;
        }
        return arr;
    }


    // 正确版本
    function insertSort2(uint[] memory arr) pure public returns( uint[] memory){
        for (uint i = 1; i < arr.length; i++) {
            uint current = arr[i];
            uint j = i;

            while (j > 0 && arr[j-1]  > current) {
                arr[j] = arr[j-1];
                j--;
            }
            arr[j] = current;
        }
        return arr;
    }


}