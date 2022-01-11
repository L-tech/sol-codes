// SPDX-License-Identifier: UNLINCENSED
pragma solidity >=0.7.0 <0.9.0;

contract Arome {
        string tokenName;
        string tokenSymbol;
        uint8 tokenDecimal = 8;
        uint256 tokenTotalSupply = 10000000;
        mapping(address => uint256) balance;

    function name() public view returns (string memory){
        return tokenName;
    }
    
    function symbol() public view returns (string memory) {
        return tokenSymbol;
    }
    
    function decimals() public view returns (uint8) {
        return tokenDecimal;
    }
    
    function totalSupply() public view returns (uint256) {
        return tokenTotalSupply;
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        return balance[_owner];
        
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balance[msg.sender] >= _value, "Insufficient Balance");
        balance[msg.sender] -= _value;
        balance[_to] += _value;
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        
    }
    
    
}
