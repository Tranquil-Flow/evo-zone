pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// TO-DO: Only msg.sender can mint? (AA impllications?)

contract SpawningStone is ERC721 {
    mapping(uint256 => string) private _tokenURIs;
    uint256 private _currentTokenId;

    struct TraitList {
        bool traitA;
    }

    mapping(address => TraitList) public traitList;

    constructor() ERC721("Spawning Stone", "SPAWN STONE") {
    }

    function mint(address to, string memory _tokenURI) external returns (uint256) {
        _currentTokenId++;
        uint256 newTokenId = _currentTokenId;
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        return newTokenId;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function addTrait() external {
        // TO-DO: add check for valid calls only
        // TO:DO make modular for all traits

    }
}
