//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Lottery is Ownable {
    uint256 private lotteryId;
    address[] public players;
    address public admin;
    address public wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IERC20 private wethContract;

    constructor() {
        lotteryId = 0;
        admin = msg.sender;
        players.push(payable(admin));
        wethContract = IERC20(wethAddress);
    }

    function getWETHBalance() public view returns (uint256) {
        return wethContract.balanceOf(address(this));
    }

    function placeBid() external {
        require(wethContract.balanceOf(msg.sender) > 0.1 ether, "Not enough WETH balance");
        wethContract.transferFrom(msg.sender, address(this), 0.1 ether);
        players.push(msg.sender);
    }

    function random() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public onlyOwner {
        require(players.length >= 3, "Not enough players in the lottery");
        address winner;
        winner = players[random() % players.length];
        resetLottery();
    }

    function resetLottery() internal {
        players = new address[](0);
    }
}
