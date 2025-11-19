// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// delegatecall和call类似,都是低级函数
// B call C , 上下文为 C(msg.sender = B), C中的状态变量会受影响
// B delegatecall C , 上下文为 B(msg.sender = A), B中的状态变量会受影响
// 注意B和C的数据存储必须相同, 变量类型,声明的前后顺序必须要相同, 否则会搞砸合约

contract C {
    uint public num;
    address public sender;
    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }

}

contract B {
    uint public num;
    address public sender;

    function callSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) = _addr.call(
            // 这里注意, 必须要写严格的类型, 不能写uint.
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    function delegateCallSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

}