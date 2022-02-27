// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Pipeline {
    struct Bucket {
        string specialization;
        string level;
        uint fee;
        uint size;
        address manager;
        string[] skills;
        mapping(address=>bool) members;
    }

    struct ModBucket {
        string specialization;
        string level;
        uint fee;
        uint size;
        address manager;
        string[] skills;
    }

    mapping(uint => Bucket) bucketlist;

    uint  public bucketIndex = 0;

    modifier isBusketManager(uint _bucketIndex) {
        require(bucketlist[_bucketIndex].manager == msg.sender, "Require Manager Level Access");
        _;
    }

    function addBucket(string memory _spec, string memory _level, uint _fee, uint _size, string[] memory _skills) external {
        Bucket storage newBucket = bucketlist[bucketIndex];
        newBucket.specialization = _spec;
        newBucket.level = _level;
        newBucket.fee = _fee;
        newBucket.size = _size;
        newBucket.manager = msg.sender;
        newBucket.skills = _skills;
        bucketIndex += 1;
    }

    function addMemberToBucket(uint _bucketIndex, address _newMemAddr) external isBusketManager(_bucketIndex) returns(bool) {
        Bucket storage b = bucketlist[bucketIndex];
        b.members[_newMemAddr] = true;
        return true;
    }

    function getBucketsLists() external view returns(ModBucket[] memory){
        ModBucket[] memory _buckets = new ModBucket[](bucketIndex+1);
        for (uint i = 0; i < bucketIndex+1; i++){
            ModBucket memory mb = ModBucket(bucketlist[i].specialization, bucketlist[i].level, bucketlist[i].fee, bucketlist[i].size, bucketlist[i].manager, bucketlist[i].skills);
            _buckets[i] = mb;
        }
        return _buckets;
    }

    function isBucketMember(uint _bucketIndex, address _newMemAddr) external view returns(bool) {
        Bucket storage b = bucketlist[_bucketIndex];
        return b.members[_newMemAddr];
    }

    function getBucketData(uint _bucketIndex) external view returns(ModBucket memory bucket){
        Bucket storage b = bucketlist[_bucketIndex];
        bucket.specialization = b.specialization;
        bucket.level = b.level;
        bucket.fee = b.fee;
        bucket.size = b.size;
        bucket.manager = b.manager;
        bucket.skills =  b.skills;
    }
    function changeBucketManager(uint _bucketIndex, address _newManAddr) external isBusketManager(_bucketIndex) {
        Bucket storage b = bucketlist[_bucketIndex];
        b.manager = _newManAddr;
    }
}
