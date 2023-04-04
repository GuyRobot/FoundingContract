// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Founding {
    constructor() {}

    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public campaignCount = 0;

    function create(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        uint256 _amountCollected,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[campaignCount];

        // Check constraint
        require(
            _deadline > block.timestamp,
            "Deadline should be in the future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = _amountCollected;
        campaign.image = _image;

        campaignCount++;

        return campaignCount - 1;
    }

    function donate(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);

        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected += amount;
        }
    }

    function getDonators(uint256 _id)
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCompaings = new Campaign[](campaignCount);

        for (uint i = 0; i < campaignCount; i++) {
            Campaign storage campaign = campaigns[i];

            allCompaings[i] = campaign;
        }

        return allCompaings;
    }
}
