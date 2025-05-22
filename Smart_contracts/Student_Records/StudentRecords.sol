// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentRecords {
    struct Student {
        string name;
        uint rollNumber;
        bool exists;
    }
    
    mapping(uint => Student) public students;
    
    uint[] public rollNumbers;
    
    event StudentAdded(uint indexed rollNumber, string name);
    
    function addStudent(string memory _name, uint _rollNumber) public {
        require(!students[_rollNumber].exists, "Student with this roll number already exists");
        
        students[_rollNumber] = Student(_name, _rollNumber, true);
        
        rollNumbers.push(_rollNumber);
        
        emit StudentAdded(_rollNumber, _name);
    }
    
    function getStudent(uint _rollNumber) public view returns (string memory, uint) {
        require(students[_rollNumber].exists, "Student with this roll number does not exist");
        
        Student memory student = students[_rollNumber];
        return (student.name, student.rollNumber);
    }
    
    function getTotalStudents() public view returns (uint) {
        return rollNumbers.length;
    }
    
    function getAllRollNumbers() public view returns (uint[] memory) {
        return rollNumbers;
    }
}
