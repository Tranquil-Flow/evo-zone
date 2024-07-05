pragma solidity 0.8.25;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// TO-DO: Only msg.sender can mint? (AA impllications?)

contract SpawningStone is Initializable, ERC721Upgradeable, OwnableUpgradeable {
    mapping(uint256 => string) private _tokenURIs;
    uint256 private _currentTokenId;

    struct Trait {
        string name;
        bool value;
    }

    mapping(uint => mapping(string => bool)) public traits;   // tokenId => (traitName => traitValue)

    error TokenDoesNotExist(uint256 tokenId);

    event TraitAdded(uint indexed tokenID, string traitName, bool value);

    function initialize() initializer public {
        __ERC721_init("Spawning Stone", "SPAWN STONE");
        __Ownable_init();
    }

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

    function addTrait(uint256 tokenId, string memory traitName, bool value) external onlyOwner {
        if (!_exists(tokenId)) {revert TokenDoesNotExist(tokenId);}
        tokenTraits[tokenId][traitName] = value;
        emit TraitAdded(tokenId, traitName, value);
    }

}
