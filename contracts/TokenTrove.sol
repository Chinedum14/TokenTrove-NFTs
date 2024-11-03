// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TokenTrove is ERC721, Ownable {
    uint256 public tokenCounter;
    uint256 public mintingFee = 0.01 ether;
    address public royaltyRecipient;
    uint256 public royaltyPercentage = 5; // 5% royalties

    // Mappings.
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => bool) public whitelist;

    constructor() ERC721("TokenTrove", "TNT") {
        tokenCounter = 0;
    }

    // 1. Metadata URI customization.
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _tokenURIs[tokenId] = _tokenURI;
    }

    // Function to retrieve metadata of a token if it exists.
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for non-existent token"
        );
        return _tokenURIs[tokenId];
    }

    // 2. Royalties.
    function setRoyalties(
        address recipient,
        uint256 percentage
    ) external onlyOwner {
        require(percentage <= 50, "Percentage too high");
        royaltyRecipient = recipient;
        royaltyPercentage = percentage;
    }

    // Get info concerning royalty amount.
    function royaltyInfo(
        uint256,
        uint256 salePrice
    ) external view returns (address, uint256) {
        uint256 royaltyAmount = (salePrice * royaltyPercentage) / 100;
        return (royaltyRecipient, royaltyAmount);
    }

    // 5. Minting fee and whitelisting.
    function addToWhitelist(address user) external onlyOwner {
        whitelist[user] = true;
    }

    // This function is responsible for minting new tokens.
    function mintNFT(
        address recipient,
        string memory uri
    ) public payable returns (uint256) {
        require(msg.value >= mintingFee, "Insufficient minting fee"); // checks if the caller has sent sufficient MF.
        require(whitelist[msg.sender], "Not whitelisted"); // checks if user is authorized to mint new tokens.
        uint256 newTokenId = tokenCounter;
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, uri);
        tokenCounter += 1;
        return newTokenId;
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can burn");
        _burn(tokenId);
    }
}
