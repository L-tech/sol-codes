// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
// A simple contract that implement a english auction system
// The sale last for a partcular period - 7 days
// Participant are outbidded by a higher bid
// The person with the highest bid get the NFT
// Every other participant is refunded
// If the buyers pays more than the value, a refund is initiated

interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
}

contract Aunction {

    IERC721 public nft;
    uint public nftId;
    address payable public seller;
    uint public currentBid = 0;
    bool public isOpen;
    uint public endSalePeriod;
    uint public highestBid;
    address public highestBidder;
    mapping(address => uint) public bids;

    event AuctionStarted(uint _time);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);
    constructor(
        address _nft,
        uint _nftId
        uint _startingBid
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    modifier isSaleOpen() {
        require(isOpen, "Sale Not Started");
        require(block.timestamp <= endSalePeriod, "Aunction Closed");
        _;
    }
     function startAuction(uint _days) external {
        require(!isOpen, "start");
        require(msg.sender == seller, "not seller");
        nft.transferFrom(msg.sender, address(this), nftId);
        isOpen = true;
        endSalePeriod = block.timestamp +  days;
        emit AuctionStarted(block.timestamp);
    }
    

}