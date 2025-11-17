// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 自定义error
error TransferNotOwner();

error TransferNotOwner2(address sender);

contract Errors{
    //一组映射,记录每个TokenId的owner
    mapping(uint256 => address) private _owner;


    // revert error
    function transferOwner1(uint256 tokenId, address newOwner)public{
        if(_owner[tokenId] != msg.sender){
            revert TransferNotOwner();
        }

        _owner[tokenId] = newOwner;
    }


    // require
    function transferOwner2(uint256 tokenId, address newOwner)public{
        require(_owner[tokenId] == msg.sender, "Transfer Not Owner");
        _owner[tokenId] = newOwner;
    }

    // assert
    function transferOwner3(uint256 tokenId, address newOwner)public{
        assert(_owner[tokenId] == msg.sender);
        _owner[tokenId] = newOwner;
    }

}