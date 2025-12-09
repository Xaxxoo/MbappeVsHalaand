// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MbappeVsHalaand is ReentrancyGuard, Ownable, Pausable {
    address public vault;
    address public USDC;
    uint256 public totalMbappeStake;
    uint256 public totalHalaandStake;

    mapping(address => mapping(string => uint256)) public stakes;
    mapping(address => mapping(string => uint256[])) public individualStakes;

    constructor(address _vault, address _usdc) Ownable(msg.sender) {
        vault = _vault;
        USDC = _usdc;
    }

    function Halaand(uint256 amount) external nonReentrant whenNotPaused {
        IERC20(USDC).transferFrom(msg.sender, vault, amount);
        stakes[msg.sender]["Halaand"] += amount;
        individualStakes[msg.sender]["Halaand"].push(amount);
        totalHalaandStake += amount;
    }

    function Mbappe(uint256 amount) external nonReentrant whenNotPaused {
        IERC20(USDC).transferFrom(msg.sender, vault, amount);
        stakes[msg.sender]["Mbappe"] += amount;
        individualStakes[msg.sender]["Mbappe"].push(amount);
        totalMbappeStake += amount;
    }

    function getStake(address user, string memory player) external view returns (uint256) {
        return stakes[user][player];
    }

    function getIndividualStakes(address user, string memory player) external view returns (uint256[] memory) {
        return individualStakes[user][player];
    }

    function getUserStakes(address user) external view returns (uint256 mbappe, uint256 haaland) {
        mbappe = stakes[user]["Mbappe"];
        haaland = stakes[user]["Halaand"];
    }

    receive() external payable {}
}