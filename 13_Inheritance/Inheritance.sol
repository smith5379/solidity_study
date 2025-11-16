// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Yeye{
    event Log(string message);


    function hip() public virtual{
        emit Log("Yeye hip()");
    }

    function pop() public virtual{
        emit Log("Yeye pop()");
    }

    function yeye() public virtual{
        emit Log("Yeye yeye()");
    }
}

contract Baba is Yeye{

    function hip() public virtual override{
        emit Log("Baba hip()");
    }

    function pop() public virtual override{
        emit Log("Baba pop()");
    }

    function baba() public virtual{
        emit Log("Baba baba()");
    }

}


contract Erzi is Yeye, Baba{


    function hip() public virtual override(Yeye, Baba){
        emit Log("Erzi hip()");
    }

    function pop() public virtual override(Yeye, Baba){
        emit Log("Erzi pop()");
    }

    function callParent() public{
        Yeye.pop();
    }

    function callParentSuper() public{
        super.pop();
    }

}

//构造函数的继承
abstract contract A{
    uint public a;
    constructor(uint _a){
        a = _a;
    }
}

//在继承时声明父构造函数的参数
contract B is A(1){
}

//在子合约的构造函数中声明构造函数的参数
contract C is A{
    constructor(uint _c) A(_c * _c){}
}