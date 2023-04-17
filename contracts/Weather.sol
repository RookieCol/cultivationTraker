// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract CultivationToken is ERC1155 {
    uint256 public tokenCounter;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => string) private _weatherDataURIs;
    mapping(uint256 => Cultivation) private _cultivationData;

    string private _name;

    struct Cultivation {
        string strain;
        uint256 plantationDate;
        uint256 harvestDate;
    }

    constructor() ERC1155("") {
        tokenCounter = 0;
        _name = "IotCultivationTracker";
    }

    function mint(address to, string memory tokenURI, string memory strain, uint256 plantationDate) external {
        _mint(to, tokenCounter, 1, "");
        _setTokenURI(tokenCounter, tokenURI);
        _cultivationData[tokenCounter] = Cultivation(strain, plantationDate, 0); // Set harvestDate to 0 initially
        tokenCounter++;
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        _tokenURIs[tokenId] = tokenURI;
    }

    function addWeatherDataURI(uint256 tokenId, string memory weatherDataURI) external {
        require(_exists(tokenId), "Token does not exist");
        require(balanceOf(msg.sender, tokenId) > 0, "Caller is not the token owner");
        _weatherDataURIs[tokenId] = weatherDataURI;
    }

    function getWeatherDataURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _weatherDataURIs[tokenId];
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return bytes(_tokenURIs[tokenId]).length > 0;
    }

    function getCultivationData(uint256 tokenId) external view returns (Cultivation memory) {
        require(_exists(tokenId), "Token does not exist");
        return _cultivationData[tokenId];
    }

    function setHarvestDate(uint256 tokenId, uint256 harvestDate) external {
        require(_exists(tokenId), "Token does not exist");
        require(balanceOf(msg.sender, tokenId) > 0, "Caller is not the token owner");
        _cultivationData[tokenId].harvestDate = harvestDate;
    }

}
