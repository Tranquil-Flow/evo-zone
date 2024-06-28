pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Monster is ERC721 {
    mapping(uint256 => string) private _tokenURIs;
    uint256 private _currentTokenId;

    address public spawningStone;

    error OnlySpawningStoneCanMint();

    constructor(address _spawningStone) ERC721("Evo Monster", "MONSTER") {
        spawningStone = _spawningStone;
    }

    modifier onlySpawningStone() {
        if (msg.sender != spawningStone) {
            revert OnlySpawningStoneCanMint();
        }
        _;
    }

    function mint(address to, string memory _tokenURI) external onlySpawningStone returns (uint256) {
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
}
