// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RSKBridgeLightning is ReentrancyGuard{

    // Mapping to store invoice IDs
    mapping(bytes32 => bool) public invoicePaid;

    mapping(address => uint256) public userBalances;

    // Event to notify when funds are locked for Lightning Network
    event SwapToLightningNetwork(address indexed user, uint256 amount, bytes32 invoiceId);
    // Event to notify when funds are unlocked from Lightning Network
    event SwapFromLightningNetwork(uint256 amount, address destination);

    // function called by user to transfer BTC to Lightning network
    function swapToLightningNetwork(uint256 amount, bytes32 invoiceId) external payable {
        require(msg.value == amount, "Amount mismatch");
        require(amount > 0, "Amount should be greater than 0");


        // Emit event for monitoring
        emit SwapToLightningNetwork(msg.sender, amount, invoiceId);
    }

    // Function called by the Canister when user wants to send tokens to RSK network
    function swapFromLightningNetwork(address _bridgedAddress, uint256 amount) external {
        // Add the rsk to the user's balance
        userBalances[_bridgedAddress] += amount;

        // Emit event for monitoring
        emit SwapFromLightningNetwork( amount, _bridgedAddress);
    }

     function claimRBTC() external nonReentrant {
        uint256 amount = userBalances[msg.sender];
        require(amount > 0, "No balance to claim");

        // Reset the user's balance
        userBalances[msg.sender] = 0;

        // Send the rBTC to the user
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to send rBTC");
    }

}
