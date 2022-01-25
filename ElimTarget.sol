// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

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

contract ElimLootGold is ERC20 {
    address owner;
    Loot loot = Loot(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
    Loot mloot = Loot(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);
    constructor(address creator) ERC20("ElimLootGold","BGLD"){
        owner = msg.sender;
        _mint(creator, 1000 * 1e18);
    }
    
    mapping(uint => bool) isAirdropClaimed;
    function claimAirdrop(uint lootNumber) public {
        if((loot.ownerOf(lootNumber) == msg.sender) && (!isAirdropClaimed[lootNumber])){
            _mint(msg.sender, 1000 * 1e18);
            isAirdropClaimed[lootNumber] = true;
        }
    }
    function mint(address to, uint value) external {
        require(msg.sender == owner, "Only ElimLoot Contract can mint");
        _mint(to, value);
    }
}




contract ElimLoot is ERC721URIStorage {
        struct Armor {
            string armorType;
            string[] armorList;
        }
    
        Loot loot = Loot(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
        Loot mloot = Loot(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);

        string[] private weapons = [
        "Warhammer",
        "Quarterstaff",
        "Maul",
        "Mace",
        "Club",
        "Katana",
        "Falchion",
        "Scimitar",
        "Long Sword",
        "Short Sword",
        "Ghost Wand",
        "Grave Wand",
        "Bone Wand",
        "Wand",
        "Grimoire",
        "Chronicle",
        "Tome",
        "Book"
    ];
    
    string[] private chestArmor = [
        "Divine Robe",
        "Silk Robe",
        "Linen Robe",
        "Robe",
        "Shirt",
        "Demon Husk",
        "Dragonskin Armor",
        "Studded Leather Armor",
        "Hard Leather Armor",
        "Leather Armor",
        "Holy Chestplate",
        "Ornate Chestplate",
        "Plate Mail",
        "Chain Mail",
        "Ring Mail"
    ];
    
    string[] private headArmor = [
        "Ancient Helm",
        "Ornate Helm",
        "Great Helm",
        "Full Helm",
        "Helm",
        "Demon Crown",
        "Dragon's Crown",
        "War Cap",
        "Leather Cap",
        "Cap",
        "Crown",
        "Divine Hood",
        "Silk Hood",
        "Linen Hood",
        "Hood"
    ];
    
    string[] private waistArmor = [
        "Ornate Belt",
        "War Belt",
        "Plated Belt",
        "Mesh Belt",
        "Heavy Belt",
        "Demonhide Belt",
        "Dragonskin Belt",
        "Studded Leather Belt",
        "Hard Leather Belt",
        "Leather Belt",
        "Brightsilk Sash",
        "Silk Sash",
        "Wool Sash",
        "Linen Sash",
        "Sash"
    ];

    string[] private handArmor = [
        "Holy Gauntlets",
        "Ornate Gauntlets",
        "Gauntlets",
        "Chain Gloves",
        "Heavy Gloves",
        "Demon's Hands",
        "Dragonskin Gloves",
        "Studded Leather Gloves",
        "Hard Leather Gloves",
        "Leather Gloves",
        "Divine Gloves",
        "Silk Gloves",
        "Wool Gloves",
        "Linen Gloves",
        "Gloves"
    ];
    


    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getWeapon(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "WEAPON", weapons);
    }
    
    function getChest(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "CHEST", chestArmor);
    }
    
    function getHead(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "HEAD", headArmor);
    }
    
    function getWaist(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "WAIST", waistArmor);
    }
    
    function getHand(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "HAND", handArmor);
    }
    

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[11] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = getWeapon(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getChest(tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = getHead(tokenId);

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = getWaist(tokenId);

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = getHand(tokenId);

        parts[10] = '</text></svg>';


        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        output = string(abi.encodePacked(output, parts[9], parts[10]));
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', toString(tokenId), '", "description": "Loot is randomized adventurer gear generated and stored on chain. Stats, images, and other functionality are intentionally omitted for others to interpret. Feel free to use Loot in any way you want.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    
    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    
    function random2(uint max, uint salt) view public returns(uint){
        return uint(keccak256(abi.encodePacked(block.coinbase, salt))) % max;
    }
    
    function pluckIndex(uint tokenId, string memory keyPrefix, uint sourceArrayLength) internal pure returns(uint256){
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        return rand % sourceArrayLength;
    }
    
    function greatness(uint index) internal pure returns(uint) {
        if(index % 21 >= 19)
            return 3;
        if(index % 21 >= 14)
            return 2;
        return 1;
    }
    
    event ElimDefeated(uint tokenId, address defeatedBy, int score);
    event PlayerDefeated(address player, uint elimLootId, int score);
    mapping(uint => bool) elimDefeated;
    uint lootBox = 0;
    
    function getArmors(uint tokenId, uint elimLootId) internal view returns(uint[4] memory, uint[4] memory, uint[4] memory) {
                
        uint[4] memory playerArmors;
        uint[4] memory elimArmors;
        uint[4] memory arrayLengths;
        
        //headArmor
        playerArmors[0] = pluckIndex(tokenId, "HEAD", headArmor.length);
        elimArmors[0] = pluckIndex(elimLootId, "HEAD", headArmor.length);
        arrayLengths[0] = headArmor.length;

        
        //chestArmor
        playerArmors[1] = pluckIndex(tokenId, "CHEST", chestArmor.length);
        elimArmors[1] = pluckIndex(elimLootId, "CHEST", chestArmor.length);
        arrayLengths[1] = chestArmor.length;

        
        //handArmor
        playerArmors[2] = pluckIndex(tokenId, "HAND", handArmor.length);
        elimArmors[2] = pluckIndex(elimLootId, "HAND", handArmor.length);
        arrayLengths[2] = handArmor.length;
        
        //waistArmor
        playerArmors[3] = pluckIndex(tokenId, "WAIST", waistArmor.length);
        elimArmors[3] = pluckIndex(elimLootId, "WAIST", waistArmor.length);
        arrayLengths[3] = waistArmor.length;
        
        return (playerArmors, elimArmors, arrayLengths);
    }
    
}
