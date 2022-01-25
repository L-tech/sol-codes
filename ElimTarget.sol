// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
interface Loot { 
    function ownerOf(uint tokenId) external returns(address);
}
contract ElimTarget is ERC20 {
    Loot loot = Loot(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
    Loot mloot = Loot(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);

    mapping(uint => bool) airdropClaimMap;

    constructor(uint256 initialSupply) ERC20("Elim", "ELM") {
        _mint(msg.sender, initialSupply);
    }

    function claimAirdrop(uint lootNumber) public {
        if((loot.ownerOf(lootNumber) == msg.sender) && (!airdropClaimMap[lootNumber])){
            _mint(msg.sender, 1000 * 1e18);
            airdropClaimMap[lootNumber] = true;
        }
    }
}
   