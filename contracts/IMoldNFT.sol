//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

interface IMoldNFT {
    function molds(uint256)
        external
        view
        returns (
            uint256,
            string memory,
            string memory
        );

    function totalMolds() external view returns (uint256);

    function ownerOf(uint256) external view returns (address);

    function transfer(uint256, address) external;
}
