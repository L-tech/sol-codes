// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Counter {
    uint public count;
    uint public min_count = 0;
    uint public max_count = 100;

    // Function to get currenct count
    function get() public view returns (uint _count) {
        return count;
    }

    // function to increment count by 1
    function inc() public {
        require(count + 1 <= max_count);
        count += 1;
    }
    // function to increment count by certain number
    function numInc(uint num) public {
        require(count + num <= max_count);
        count += num;
    }
    // function to decrement count by 1
    function dec() public {
        require(count - 1 >= min_count);
        count -= 1;
    }
    // function to decrement count by a certain number
    function numDec(uint num) public {
        require(count - num >= min_count);
        count -= num;
    }

}
