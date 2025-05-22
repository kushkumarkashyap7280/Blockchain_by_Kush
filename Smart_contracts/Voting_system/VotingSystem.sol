// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(address => bool) public hasVoted;
    
    mapping(uint => Candidate) public candidates;
    
    uint public candidatesCount;
    
    event VoteCast(address indexed voter, uint indexed candidateId);
    
    constructor(string[] memory _candidateNames) {
        require(_candidateNames.length > 0, "At least one candidate is required");
        
        for (uint i = 0; i < _candidateNames.length; i++) {
            addCandidate(_candidateNames[i]);
        }
    }
    
    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }
    
    function vote(uint _candidateId) public {
        require(!hasVoted[msg.sender], "You have already voted");
        
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        
        hasVoted[msg.sender] = true;
        
        candidates[_candidateId].voteCount++;
        
        emit VoteCast(msg.sender, _candidateId);
    }
    
    function getCandidate(uint _candidateId) public view returns (uint, string memory, uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
}
