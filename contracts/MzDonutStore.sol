// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract MzDountStore {
    address public owner;
    mapping(address => uint) public donutBalances;

    constructor() {
        owner  = msg.sender;
        donutBalances[address(this)] = 100;
    }

    function getMachineDonutBalance() public view returns(uint) {
        return donutBalances[address(this)]; 
    }
    function getMachineEtherBalance() public view returns(uint) {
        return owner.balance;
    }
    function restockDonutBalance(uint _amount) public {
        require(msg.sender == owner, "only the owner can restock donuts this machine");
        donutBalances[address(this)] += _amount;
    }
    
    function getCustomerDonutBalance(address _address) public view returns(uint) {
        return donutBalances[_address]; 
    }
    function getCustomerEtherBalance(address _address) public view returns(uint) {
        return (_address.balance);
    }

    function purchase(uint _amount) public payable {
        require(msg.sender.balance >= _amount * 0.1 ether, "You must have a least 0.1 Ether per donut");
        require(msg.value == _amount * 0.1 ether, "You must pay 0.1 Ether per donut");
        require(donutBalances[address(this)] >= _amount, "not enough donuts in stock to fulfill purchase request");

        donutBalances[address(this)] -= _amount;
        donutBalances[msg.sender] += _amount;
        payable (owner).transfer(_amount * 0.1 ether);
    }
}