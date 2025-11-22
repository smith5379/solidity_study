// SPDX-License-Identifier: MIT
pragma solidity ~0.8.0;

contract Voting{
    mapping(address cadidate => uint256 votingCount) public votingCountMap;

    address[] private votingCadidates;

    function vote(address cadidate) public {
        if(votingCountMap[cadidate] == 0){
            votingCadidates.push(cadidate);
        }
        votingCountMap[cadidate] += 1;
    }

    function getVotes(address cadidate) public view returns(uint256 voteingCount) {
        return votingCountMap[cadidate];
    }

    function resetVotes() public {
        for (uint256 i = 0; i < votingCadidates.length; i++) {
            delete votingCountMap[votingCadidates[i]];
        }
    
    }


}