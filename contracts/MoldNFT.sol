//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MoldNFT is ERC721URIStorage, Ownable {
    struct IMoldNFT {
        uint256 id;
        string name;
        string uri;
    }
    IMoldNFT[] public molds;
    uint256 public totalMolds;
    mapping(address => bool) private governance;

    event Mint(uint256 id, string name, string uri);

    constructor() ERC721("Mold Lottery Token", "MOLD") {
        totalMolds = 0;
        governance[msg.sender] = true;
    }

    modifier onlyLiveToken(uint256 _nftId) {
        require(ownerOf(_nftId) != address(0), "Invalid NFT");
        _;
    }

    function addMinter(address _minter) public onlyOwner {
        require(_minter != address(0), "Invalid address");
        governance[_minter] = true;
    }

    function removeMinter(address _minter) public onlyOwner {
        require(_minter != address(0), "Invalid address");
        governance[_minter] = false;
    }

    function mint(string memory _name, string memory _uri) external returns (uint256) {
        require(governance[msg.sender], "No Permission");

        IMoldNFT memory nft;
        nft.id = totalMolds;
        nft.name = _name;
        nft.uri = _uri;

        molds.push(nft);
        totalMolds++;

        _mint(msg.sender, nft.id);
        _setTokenURI(nft.id, _uri);

        emit Mint(nft.id, nft.name, nft.uri);

        return nft.id;
    }

    function burn(uint256 _nftId) external onlyLiveToken(_nftId) {
        require(_exists(_nftId), "Non existed NFT");

        _burn(_nftId);

        molds[_nftId].id = 0;
        molds[_nftId].name = "";
        molds[_nftId].uri = "";
        totalMolds--;
    }

    function transfer(uint256 _nftId, address _target) external onlyLiveToken(_nftId) {
        require(_exists(_nftId), "Non existed NFT");
        require(ownerOf(_nftId) == msg.sender || getApproved(_nftId) == msg.sender, "Not approved");
        require(_target != address(0), "Invalid address");
        _transfer(ownerOf(_nftId), _target, _nftId);
    }
}
