// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherSplitter {
    address payable public recipient1;
    address payable public recipient2;
    address payable public recipient3;
    
    event EtherSplit(address sender, uint totalAmount, uint splitAmount);
    
    constructor(address payable _recipient1, address payable _recipient2, address payable _recipient3) {
        require(_recipient1 != address(0) && _recipient2 != address(0) && _recipient3 != address(0), 
                "Recipients cannot be zero address");
        
        recipient1 = _recipient1;
        recipient2 = _recipient2;
        recipient3 = _recipient3;
    }
    
    receive() external payable {
        splitEther();
    }
    
    function deposit() public payable {
        splitEther();
    }
    
    function splitEther() private {
        require(msg.value > 0, "Must send some Ether");
        
        uint splitAmount = msg.value / 3;
        
        recipient1.transfer(splitAmount);
        recipient2.transfer(splitAmount);
        
        uint remainder = msg.value - (splitAmount * 2);
        recipient3.transfer(splitAmount + remainder);
        
        emit EtherSplit(msg.sender, msg.value, splitAmount);
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function updateRecipients(
        address payable _recipient1, 
        address payable _recipient2, 
        address payable _recipient3
    ) public {
        require(_recipient1 != address(0) && _recipient2 != address(0) && _recipient3 != address(0), 
                "Recipients cannot be zero address");
        
        recipient1 = _recipient1;
        recipient2 = _recipient2;
        recipient3 = _recipient3;
    }
}
