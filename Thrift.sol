// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract Purse {
    uint thriftIndex = 0;
    struct thriftOrg {
        address[] thrifters;
        address lastCollector;
        uint256 maturityTime;
        mapping(address=>uint) collections;
        bool valid;
        mapping(address => uint[]) thriftsAmountCollected;
        uint totalAmount;

    }
    mapping(uint=>thriftOrg) public thrifts;

    function addThrift() external returns(uint _index) {
        thriftOrg storage newThrift = thrifts[thriftIndex];
        newThrift.maturityTime = block.timestamp + 100;
        newThrift.valid = true;
        thriftIndex += 1;
    }
    function joinThrift(uint _thriftId) external payable {
        confirmJoinRequest(_thriftId);
        thriftOrg storage t = thrifts[thriftIndex];
        t.thrifters.push(msg.sender);
        t.collections[msg.sender] += msg.value;
        t.totalAmount += msg.value;
    }

    function confirmJoinRequest(uint _thriftId) private {
        assert(thrifts[_thriftId].valid);
        
    }

    function getNextCollector(address[] memory _in, address _last) internal returns(address _next, uint _index) {
        assert(_in.length > 1);
        if(_last == address(0)) {
            _next = address(_in[0]);
        } else {
            uint i__ = findIndex(_in, _last);
            _next = _in[i__ + 1];
            _index = i__;
        }
    }

    function findIndex(address[] memory _in, address _target ) internal returns (uint _index) {
        assert(_in.length > 1);
        for(uint i=0; i < _in.length; i++) {
            if(_target == _in[i]) {
                _index = i;
            }
        }
    }

    function reset(uint _thriftId) private {
        thrifts[_thriftId].lastCollector = address(0);
        thrifts[_thriftId].maturityTime += 100;
    }

    function collecThrift(uint _thriftId) public {
        thriftOrg storage t = thrifts[_thriftId];
        (address nextCollector, uint index) = getNextCollector(t.thrifters, t.lastCollector);
        assert(msg.sender == nextCollector);
        assert(block.timestamp >= t.maturityTime);
        payable(msg.sender).transfer(t.totalAmount);

        if(index == t.thrifters.length -1) {
            reset(_thriftId);
            t.thriftsAmountCollected[msg.sender].push(t.totalAmount);
        }
    }
}