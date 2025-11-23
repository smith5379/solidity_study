// SPDX-License-Identifier: MIT
pragma solidity ~0.8.0;

contract Int2Roma{

    function int2Roma(uint256 num) public pure returns(string memory res){
        uint256[13] memory arr1 = [uint256(1000), 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        string[13] memory arr2 = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];

        uint256 len = arr1.length;

        for (uint256 i = 0; i < len; i++) {
            while (num >= arr1[i]) {
                num -= arr1[i];
                res = string(abi.encodePacked(res, arr2[i]));
            }
        }
    }

}