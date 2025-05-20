// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OwnerOnly {
    address public owner;
    uint public secretValue;
    
    event SecretValueChanged(uint newValue);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    function setSecretValue(uint _newValue) public onlyOwner {
        secretValue = _newValue;
        emit SecretValueChanged(_newValue);
    }
    
    function getSecretValue() public view returns (uint) {
        return secretValue;
    }
    
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner cannot be the zero address");
        owner = _newOwner;
    }
}
