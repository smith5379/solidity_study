// SPDX-License-Identifier: MIT
pragma solidity ~0.8.0;

contract Roma2Int {

    function romaToInt(string memory romaString) public pure returns(uint256 res){
        bytes memory romaArr = bytes(romaString);
        for (uint256 i = 0; i < romaArr.length; i++) {
            uint256 value = romaValue(romaArr[i]);
            if(i < romaArr.length -1 && value < romaValue(romaArr[i+1])){
                res -= value;
            }else {
                res += value;
            }

        }
        return res;
    }

    function romaValue(bytes1 romaString ) private pure returns(uint256){
        if(romaString == "I"){return 1; }
        if(romaString == "V"){return 5; }
        if(romaString == "X"){return 10; }
        if(romaString == "L"){return 50; }
        if(romaString == "C"){return 100; }
        if(romaString == "D"){return 500; }
        if(romaString == "M"){return 1000; }

    }

}