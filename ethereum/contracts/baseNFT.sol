//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract baseNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;
    bool public paused = false;

    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor(address marketplaceAddress) ERC721("Metaverse Tokens","METT") {
        contractAddress = marketplaceAddress;
    }

    function createToken(string memory tokenURI) public returns(uint) {
        require(!paused);
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender,newItemId);
        _setTokenURI(newItemId,tokenURI);
        setApprovalForAll(contractAddress,true);
        return newItemId;
    }

    // from ERC721Enumerable
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < ERC721.balanceOf(owner), "owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    // function only for owner
    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function withdraw() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }

}
