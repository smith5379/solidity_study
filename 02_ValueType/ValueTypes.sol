// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract ValueTypes{
    // 布尔值
    bool public _bool = true;
    // 布尔运算
    bool public _bool1 = !_bool;
    bool public _bool2 = _bool && _bool1;
    bool public _bool3 = _bool || _bool1;
    bool public _bool4 = _bool == _bool1;
    bool public _bool5 = _bool != _bool1;

}