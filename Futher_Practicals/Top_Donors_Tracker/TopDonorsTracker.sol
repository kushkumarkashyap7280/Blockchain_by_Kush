// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TopDonorsTracker {
    struct Donor {
        address addr;
        uint amount;
    }
    
    Donor[3] public topDonors;
    
    mapping(address => uint) public donations;
    
    uint public totalDonations;
    
    event DonationReceived(address indexed donor, uint amount);
    event TopDonorsUpdated();
    
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        
        donations[msg.sender] += msg.value;
        
        totalDonations += msg.value;
        
        updateTopDonors(msg.sender, donations[msg.sender]);
        
        emit DonationReceived(msg.sender, msg.value);
    }
    
    function updateTopDonors(address _donor, uint _amount) private {
        for (uint i = 0; i < 3; i++) {
            if (topDonors[i].addr == _donor) {
                topDonors[i].amount = _amount;
                
                sortTopDonors();
                emit TopDonorsUpdated();
                return;
            }
        }
        
        if (topDonors[2].amount < _amount) {
            topDonors[2] = Donor(_donor, _amount);
            
            sortTopDonors();
            emit TopDonorsUpdated();
        }
    }
    
    function sortTopDonors() private {
        for (uint i = 0; i < 2; i++) {
            for (uint j = 0; j < 2 - i; j++) {
                if (topDonors[j].amount < topDonors[j + 1].amount) {
                    Donor memory temp = topDonors[j];
                    topDonors[j] = topDonors[j + 1];
                    topDonors[j + 1] = temp;
                }
            }
        }
    }
    
    function getTopDonors() public view returns (address[3] memory, uint[3] memory) {
        address[3] memory addresses;
        uint[3] memory amounts;
        
        for (uint i = 0; i < 3; i++) {
            addresses[i] = topDonors[i].addr;
            amounts[i] = topDonors[i].amount;
        }
        
        return (addresses, amounts);
    }
    
    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
