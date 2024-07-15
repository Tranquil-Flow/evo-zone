pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Monster is ERC721 {
    mapping(uint => string) private _tokenURIs;
    uint private _currentTokenId;

    mapping(uint256 => Attributes) private _monsterAttributes;
    address public spawningStone;

    struct Attributes {
        uint health;
        uint attack;
        uint defence;
        uint speed;
    }

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

    function mint(
        address to,
        string memory _tokenURI,
        uint health,
        uint attack,
        uint defense,
        uint speed
        ) external onlySpawningStone returns (uint) {
        _currentTokenId++;
        uint newTokenId = _currentTokenId;
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        _setMonsterAttributes(newTokenId, health, attack, defense, speed);
        return newTokenId;
    }

    function _setTokenURI(uint tokenId, string memory _tokenURI) internal {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _setMonsterAttributes(
        uint tokenId,
        uint health,
        uint attack,
        uint defense,
        uint speed
        ) internal {
        _monsterAttributes[tokenId] = Attributes(health, attack, defense, speed);
    }

    function tokenURI(uint tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function getMonsterAttributes(uint tokenId) external view returns (Attributes memory) {
        return _monsterAttributes[tokenId];
    }
}
