// SPDX-License-Identifier: UNLINCENSED
pragma solidity ^0.8.7;
contract Poll {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        string name;
        uint totalVotes;
    }
    address presidingOfficer;
    mapping (address=>Voter) voters;

    Proposal[] public proposals;
    constructor(string[] memory _names) {
        presidingOfficer = msg.sender;
        voters[presidingOfficer].weight = 1;
        for (uint i = 0; i < _names.length; i++) {
            proposals.push(Proposal({
                name: _names[i],
                totalVotes: 0
            }));
        }
    }
    modifier isPrecidingOfficer() {
        require(msg.sender == presidingOfficer, "Access Denied - Not Presiding Officer");
        _;
    }

    function sufferage(address _voter) external isPrecidingOfficer {
        require(!voters[_voter].voted, "Voter Already Voted");
        require(voters[_voter].weight == 0, "Voting Right Already Exercised");
        voters[_voter].weight = 1;

    }

    function delegate(address _to) external {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Voter Already Voted");
        require(_to != msg.sender, "Self-delegation isn't allowed.");
        require(sender.weight >= 1, "No Voting Rights, Can not delegate");
        sender.delegate = _to;

        Voter storage delegate_ = voters[_to];
        if (delegate_.voted) {
            proposals[delegate_.vote].totalVotes += sender.weight;
            sender.voted = true;
        } else {
            delegate_.weight += sender.weight;
        }

    }

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight >= 1, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].totalVotes += sender.weight;
    }

    function winningProposal() public view returns (uint _winningProposal)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].totalVotes > winningVoteCount) {
                winningVoteCount = proposals[p].totalVotes;
                _winningProposal = p;
            }
        }
    }

    function winnerName() external view returns (string memory _winnerName)
    {
        return proposals[winningProposal()].name;
    }

    function winningMargin() external view returns (uint _percentage) {
        // return margin of victory in percentage
        uint winningProposalVotes= proposals[winningProposal()].totalVotes;
        
        uint totalVotesCount = 0;
        for(uint i = 0; i < proposals.length; i++) {
            totalVotesCount += proposals[i].totalVotes; 
            
        }
        uint margin = (winningProposalVotes * 100);

        return (margin / totalVotesCount);
    }

}