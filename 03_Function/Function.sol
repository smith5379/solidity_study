// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract FunctionType{
    
    uint256 public number = 5;
    
    // 函数类型
    // function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types)]
    function add() external{
        number = number + 1;
    }

    // pure 不能读取也不能写入链上的状态变量
    function addPure(uint256 _number) external pure returns(uint256 new_number){
        new_number = _number + 1;
    }

    // view 能读取但不能写入链上的状态变量
    function addView() external view returns(uint256 new_number){
        new_number = number + 1;
    }
    

    // 非pure/view 可以读取也可以写入状态变量
    // internal 内部函数
    function minus() internal {
        number = number - 1;
    }

    function minusCall() external {
        minus();
    }

    //payable: 能给合约支付eth的函数
    function minusPayable() external payable returns(uint256 balance){
        minus();
        balance = address(this).balance;
    }

    //public: 内部和外部均可见
    //external: 只能从合约外部访问(内部可以通过this.f() 来调用, f是函数名)
    //internal: 只能从合约内部访问, 继承的合约可以用.
    //private: 只能从本合约内部访问, 继承的合约也不能使用
    // 可见范围从大到小 public > external > internal > private

}