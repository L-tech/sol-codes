// SPDX-License-Identifier: UNLINCENSED
pragma solidity >=0.7.0 <0.9.0;
interface ECM {

    sendNotification(address user, string memory title, string memory text, string memory image) external payable;
    getUserPrice(address user) external;

}

contract Arome {
    ECM ecm = ECM(0x2F04837B299d8eD4cd8d6bBa69F48EdFEc401daD);


    string tokenName;
    string tokenSymbol;
    uint8 tokenDecimal = 8;
    uint256 tokenTotalSupply = 10000000;
    mapping(address => uint256) balance;

    mapping(uint => bool) blockMined;
    uint totalMinted = 0;

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
        if(msg.value >= ecm.getUserPrice(spender)) {
            ecm.sendNotification{value: msg.value} (...);
        }
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
    
    
    function sqrt(uint x) internal pure returns (uint y) {
    uint z = (x + 1) / 2;
    y = x;
    while (z < y) {
        y = z;
        z = (x / z + z) / 2;
        }
    }
    
    function square(uint x) internal pure returns(uint) {
      return x*x;
    }

    function calculateMint(uint amountInWei) internal view returns(uint) {
      return sqrt((amountInWei * 2) + square(totalMinted)) - totalMinted;
    }

    // n = number of coins returned 
    function calculateUnmint(uint n) internal view returns (uint) {
        return (square(totalMinted) - square(totalMinted - n)) / 2;
    }
    
    function mint() public payable returns(uint){
      uint coinsToBeMinted = calculateMint(msg.value);
      assert(totalMinted + coinsToBeMinted < 10000000 * 1e8);
      totalMinted += coinsToBeMinted;
      balance[msg.sender] += coinsToBeMinted;
      return coinsToBeMinted;
    }
    
    function unmint(uint coinsBeingReturned) public payable {
      uint weiToBeReturned = calculateUnmint(coinsBeingReturned);
      assert(balance[msg.sender] > coinsBeingReturned);
      payable(msg.sender).transfer(weiToBeReturned);
      balance[msg.sender] -= coinsBeingReturned;
      totalMinted -= coinsBeingReturned;
    }
    
    
}
