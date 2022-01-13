// SPDX-License-Identifier: UNLINCENSED
pragma solidity >=0.7.0 <0.9.0;

contract Arome {
        string tokenName;
        string tokenSymbol;
        uint8 tokenDecimal = 8;
        uint256 tokenTotalSupply = 10000000;
        mapping(address => uint256) balance;

        mapping(uint => bool) blockMined;
        uint totalMinted = 1000000 * 1e8;

        event Transfer(address indexed _from, address indexed _to, uint256 _value);
        event Approval(address indexed _owner, address indexed _spender, uint256 _value);

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
        if(balance[_from] < _value)
            return false;
        
        if(allowances[_from][msg.sender] < _value)
            return false;
            
        balance[_from] -= _value;
        balance[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        
        return true;
    }
    
    mapping(address => mapping(address => uint)) allowances;
    
    
    function approve(address _spender, uint256 _value) public {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    } //1M that has been minted to the deployer in constructor()
    
    function mine() public returns(bool success){
        if(blockMined[block.number]){
            return false;
        }
        balance[msg.sender] = balance[msg.sender] + 10*1e8;
        totalMinted = totalMinted + 10*1e8;
        return true;
    }
    
    
}
