// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
/* 继承树：
  God
 /  \
Adam Eve
 \  /
people
*/
contract God{
    event Log(string message);

    function foo() public virtual{
        emit Log("God.foo called");
    }

    function bar() public virtual{
        emit Log("God.foo called");
    }
}

contract Adam is God{

    function foo() public virtual override {
        emit Log("Adam.foo called");
        super.foo();
    }

    function bar() public virtual override{
        emit Log("Adam.foo called");
        super.bar();
    }
}


contract Eve is God{


    function foo() public virtual override{
        emit Log("Eve.foo called");
        super.foo();
    }

    function bar() public virtual override{
        emit Log("Eve.foo called");
        super.bar();
    }
}


contract People is Adam, Eve{


    function foo() public override(Adam,Eve){
        emit Log("People.foo called");
        super.foo();
    }

    //people中的super.bar()会依次调用Eve、Adam，最后是God合约
    function bar() public override(Adam,Eve){
        emit Log("People.foo called");
        super.bar();
    }
}