//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract DevPro {
    struct Dev {
        string name;
        string pLink;
        string experience;
    }

    mapping(uint => Dev) public devProfiles;

    uint public devProIndex = 0;
    event NewDev(Dev _dev);
    
    function addDevProfile(Dev memory dev) external {
        devProfiles[devProIndex] = dev;  
        devProIndex += 1;
        emit NewDev(dev);
    }

    function getDevProfile(uint _devProIndex) external view returns(Dev memory) {
        return devProfiles[_devProIndex];
    }
    
}
