// SPDX-License-Identifier: MIT
pragma solidity ~0.8.0;

contract ReverseString{
    
    function resetVotes(string memory str) public pure returns(string memory){
        bytes memory strBytes = bytes(str);
        bytes memory resBytes = new bytes(strBytes.length);


        for (uint256 i = 0; i < strBytes.length; i++) {
            resBytes[i] = strBytes[strBytes.length - i - 1];
        }

        return string(resBytes);

    }


}