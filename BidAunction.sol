// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
// A simple contract that implement a dutch aunction system
// A value is discounted based as time per passes by
// The NFT is sold when someone pay the current value of the NFT as at the time purchase or more
// If the buyers pays more than the value, a refund is initiated
interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint _nftId
    ) external;
}


contract BidAunction {
    uint private constant openPeriod = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable owner;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    event NFTPurchased(address _address, uint _amount);

    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    ) {
        owner = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + openPeriod;
        discountRate = _discountRate;
        require(_startingPrice >= _discountRate * openPeriod + 1, "starting price < minimun");
        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");
        uint price = getPrice();
        require(msg.value >= price, "ETH < price");
        nft.transferFrom(owner, msg.sender, nftId);
        emit NFTPurchased(msg.sender, price);
        // Refund buyer with amount over the current price
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        selfdestruct(owner);
    }


    
}