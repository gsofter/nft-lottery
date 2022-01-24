//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IMoldNFT.sol";

contract Lottery is Ownable {
    uint256 private lotteryId;
    address[] public players;
    address public admin;
    address public constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IERC20 private wethContract;
    IMoldNFT private moldNftContract;
    bool private moldNftInitialized;
    bool private lotteryCreated;

    event NftInitialized(address nftAddress);
    event LotteryCreated(uint256 lotteryId, string _lotteryName);
    event LotteryBidPlaced(uint256 lotteryId, address bidder);
    event LotteryWinnerPicked(uint256 lotteryId, address winner);
    event LotteryClosed(uint256 lotteryId);

    constructor() {
        lotteryId = 0;
        admin = msg.sender;
        players.push(admin);
        wethContract = IERC20(wethAddress);
        moldNftInitialized = false;
        lotteryCreated = false;
    }

    function createLottery(string memory _lotteryName) public onlyOwner {
        require(moldNftInitialized == true, "NFT should initialized!");
        require(lotteryCreated == false, "Lottery already created!");
        lotteryId = moldNftContract.mint(_lotteryName);
        lotteryCreated = true;
        emit LotteryCreated(lotteryId, _lotteryName);
    }

    function initializeNFT(address _moldAddress) external onlyOwner {
        require(_moldAddress != address(0), "Invalid address");
        moldNftContract = IMoldNFT(_moldAddress);
        moldNftInitialized = true;
        emit NftInitialized(_moldAddress);
    }

    function getWETHBalance() public view returns (uint256) {
        return wethContract.balanceOf(address(this));
    }

    function placeBid() external {
        require(msg.sender != admin, "Admin can't place bid!");
        require(lotteryCreated == true, "Lottery not started!");
        require(wethContract.balanceOf(msg.sender) > 0.1 ether, "Not enough WETH balance");
        wethContract.transferFrom(msg.sender, address(this), 0.1 ether);
        players.push(msg.sender);
        emit LotteryBidPlaced(lotteryId, msg.sender);
    }

    function random() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public onlyOwner {
        require(lotteryCreated == true, "Lottery not started!");
        require(players.length >= 3, "Not enough players in the lottery");
        address winner;
        winner = players[random() % players.length];
        moldNftContract.transfer(lotteryId, winner);
        emit LotteryWinnerPicked(lotteryId, winner);
        resetLottery();
    }

    function resetLottery() internal {
        players = new address[](0);
        lotteryCreated = false;
        emit LotteryClosed(lotteryId);
    }
}
