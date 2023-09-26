// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}


// File contracts/RSKBridgeLightning.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;
contract RSKBridgeLightning is ReentrancyGuard{

    // Mapping to store invoice IDs
    mapping(bytes32 => bool) public invoicePaid;

    mapping(address => uint256) public userBalances;

    // Event to notify when funds are locked for Lightning Network
    event SwapToLightningNetwork(address indexed user, uint256 amount, string invoiceId);
    // Event to notify when funds are unlocked from Lightning Network
    event SwapFromLightningNetwork(uint256 amount, address destination);

    // function called by user to transfer BTC to Lightning network
    function swapToLightningNetwork(uint256 amount, string calldata invoiceId) external payable {
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
