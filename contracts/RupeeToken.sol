// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract RupeeToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint public blockReward;

    // Event declaration
    event BlockRewardUpdated(uint256 oldReward, uint256 newReward);

    constructor(uint256 cap, uint256 reward)
        ERC20("RupeeToken", "PKR")
        ERC20Capped(cap * (10 ** decimals()))
    {
        owner = payable(msg.sender);
        _mint(owner, 70_000_000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    /**
     * @dev This internal function is now used to resolve the inheritance conflict
     * between ERC20 and ERC20Capped, both of which define an _update function.
     * We also place our custom logic here.
     */
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Capped) // Explicitly override both parent functions
    {
        // This is your custom logic to mint a reward on every token transfer.
        // It does not run on the initial mint (from == address(0)) or on burns (to == address(0)).
        if (from != address(0) && to != address(0)) {
            // Note: This mints new tokens to the owner on EVERY transfer.
            // This will increase the total supply over time.
            _mint(owner, blockReward);
        }

        // This executes the original logic from the parent contracts,
        // including the supply cap check and the actual token transfer.
        super._update(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        uint256 oldReward = blockReward;
        blockReward = reward * (10 ** decimals());
        emit BlockRewardUpdated(oldReward, blockReward);
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner can use this function");
        _;
    }
}