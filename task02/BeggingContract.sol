// SPDX-License-Identifier: MIT
pragma solidity ~0.8;

contract BeggingContract{

    mapping(address => uint256) donateMapping;

    address public _owner;

    modifier onlyOwner{
        require(msg.sender == _owner, "You Not Owner");
        _;
    }

    constructor(address owner){
        _owner = owner;
    }

    function donate() public payable {
        donateMapping[msg.sender] = msg.value;
    }

    function withdraw() public payable onlyOwner{
        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
        // (bool success, ) = msg.sender.call{value: address(this).balance}("");
        // require(success, "withdraw failed");
    }


    function getDonation(address account) public view returns(uint256){
        return donateMapping[account];
    }


}