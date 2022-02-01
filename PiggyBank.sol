// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract PiggyBank {
    address payable public owner;
    event Deposit(uint _amount, uint _time);
    event Withdrawal(uint _amount, uint _time);
    constructor() {
        owner = payable(msg.sender);
    }
    modifier onlyOwner() {
        require(owner == msg.sender, "Access Denied");
        _;
    }
    function withdraw() external onlyOwner () {
        emit Withdrawal(address(this).balance, block.timestamp);
        selfdestruct(payable(msg.sender));
    }

    receive() payable external {
        emit Deposit(msg.value, block.timestamp);
    }

}
