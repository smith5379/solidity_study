// SPDX-License-Identifier: MIT
pragma solidity ~0.8.0;

contract BinarySearch{

    function binarySearch(int256[] memory nums, int256 target) public pure returns(uint256 res){

        uint256 start = 0;
        uint256 end = nums.length - 1;
        while (start <= end) {
            uint256 mid = uint256((start + end) / 2);
            if (nums[mid] == target) {
                return mid;
            } else if (nums[mid] > target) {
                if(mid == 0){
                    break;
                }
                end = mid - 1;
            } else {
                start = mid + 1;
            }
        }
        return type(uint256).max;

    }

}