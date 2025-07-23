// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract RupeeToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint public blockReward;

    event BlockRewardUpdated(uint256 oldReward, uint256 newReward);

    constructor(uint256 cap, uint256 reward)
        ERC20("RupeeToken", "PKR")
        ERC20Capped(cap * (10 ** decimals()))
    {
        owner = payable(msg.sender);
        _mint(owner, 70_000_000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Capped)
    {
        if (from != address(0) && to != address(0)) {
            _mint(owner, blockReward);
        }

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
