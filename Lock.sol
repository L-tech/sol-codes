// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
contract bin{
    uint32[] public o;
    uint32[] public s;
    function binarySearch(
        uint256 l,
        uint256 r,
        uint256 x
    ) public view returns (uint256) {
        // Check base case
        if (r >= l) {
            uint256 mid = l + (r - l) / 2;

            // If element is present at the middle itself
            if (o[mid] == x) {
                return mid;
            }
            // If element is smaller than mid, then it
            //can only be present in left subarray
            else if (o[mid] > x) {
                return binarySearch(l, mid - 1, x);

                // Else the element can only be present
                // in right subarray
            } else {
                return binarySearch(mid + 1, r, x);
            }
        } else {
            // Element is not present in the array
            revert("Element is not present in the array");
        }
    }

    function getTokenId(uint256 tokenId) public view returns (uint256) {
        uint256 pos = binarySearch(0, o.length - 1, tokenId);
        return (s[pos]);
    }

    
    function parsePostalCode(bytes memory postalCode)
        public
        pure
        returns (uint8[4] memory)
    {
        return [
            uint8(postalCode[0]),
            uint8(postalCode[1]),
            uint8(postalCode[2]),
            uint8(postalCode[3])
        ];
    }

    // /// @dev Parse token id into bytes form
    // function getPostalCode(uint256 tokenId) public view returns (bytes memory) {
    //     uint256 _tokenId = getTokenId(tokenId);
    //     return abi.encodePacked(uint32(_tokenId));
    // 
    }


    function convertToTraits(uint256[7] calldata _inputCards) public view returns(uint8[4][7] memory out_){
        bytes[] memory b=new bytes[](7);
        for(uint i=0;i<7;i++){
            b[i]=abi.encodePacked(uint32(_inputCards[i]));
            out_[i]=parsePostalCode(b[i]);
        }
    }

    function convertToTrait(uint32 _card) public view returns(uint8[4] memory out_){
        bytes memory hexi=abi.encodePacked(_card);
        out_=parsePostalCode(hexi);
    }

    function compareCards(uint32[7] memory _cards) public view returns(bool street){
        street=true;
        uint8[] memory c=new uint8[](4);
        c[0]= convertToTrait(_cards[1])[0];
        c[1]= convertToTrait(_cards[1])[1];
        c[2]= convertToTrait(_cards[1])[2];
        c[3]= convertToTrait(_cards[1])[3];
        for(uint i=1;i<_cards.length;i++){
            uint8[4] memory next =convertToTrait(_cards[i]);
                for(uint j=0;j<4;j++){
                    if(next[j]!=c[j]){
                        street=false;
                    }
                }

        }
    }
    

}