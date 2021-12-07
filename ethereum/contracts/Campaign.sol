//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract CampaignFactory {
//     address[] public deployedCampaigns;
    
//     function createCampaign(uint minimum) public {
//         address newCampaign = address(new Campaign(minimum, msg.sender));
//         deployedCampaigns.push(newCampaign);
//     }
    
//     function getDeployedCampaigns() public view returns (address[] memory) {
//         return deployedCampaigns;
//     }
    
// }

contract Campaign {
    
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    uint public numCreated;
    address[] public allaccount;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint minimum, address creator) {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true;
        approversCount++;
        allaccount.push(msg.sender);
    }
    
    function createRequest(string memory description, uint value, address payable recipient) public restricted {
        Request storage newRequest = requests[numCreated];
        newRequest.description = description;
        newRequest.value = value;
        newRequest.recipient = recipient;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
        numCreated++;
        // Request({
        //    description: description,
        //    value: value,
        //    recipient: recipient,
        //    complete: false,
        //    approvalCount: 0
        // });    
        
        //alternative syntax Request(description, value, recipient, false);
        //storage -> like hard drive , vs , memmory -> like ram or temporaly keep data
        
        //requests.push(newRequest);
    }
    
    function approveRequests(uint index) public {
        Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
        
    }
    
    function accountList() public view returns (address[] memory) {
        return allaccount;
    }
    
}

