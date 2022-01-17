// SPDX-License-Identifier: UNLINCENSED
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MyNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
	Counters.Counter private _tokenIdCounter;
    mapping(uint => string) private_uris;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
        
    }
    function safeMint(address _to, string memory _uri) public returns (uint) {
        _tokenIdCounter.increment();
        _safeMint(_to, _tokenIdCounter.current());
        private_uris[_tokenIdCounter.current()] = _uri;
        return _tokenIdCounter.current();
    }

    function tokenURI(uint _tokenID) public view override returns (string memory) {
        return private_uris[_tokenID];
    }

}