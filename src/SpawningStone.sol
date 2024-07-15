pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// TO-DO: Only msg.sender can mint? (AA impllications?)
// TO-DO: Implement logic for minting monsters with determined Attribute levels

contract SpawningStone is ERC721, Ownable {
    mapping(uint => string) private _tokenURIs;
    uint private _currentTokenId;
    
    struct Trait {
        string name;
        bool value;
    }

    string[] public traitList;
    mapping(uint => mapping(string => bool)) public spawningStoneTraits;   // tokenId => (traitName => traitValue)
    mapping(uint => uint) public spawningStoneSouls;

    error TokenDoesNotExist(uint tokenId);
    error TraitNotValid(string traitName);

    event GlobalTraitAdded(string traitName);
    event TraitAdded(uint indexed tokenID, string traitName, bool value);

    constructor() ERC721("Spawning Stone", "SPAWN STONE") {
    }

    function mint(address to, string memory _tokenURI) external returns (uint) {
        _currentTokenId++;
        uint newTokenId = _currentTokenId;
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        return newTokenId;
    }

    function _setTokenURI(uint tokenId, string memory _tokenURI) internal {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function getTrait(uint tokenId, string memory traitName) public view returns (bool) {
        if (!_exists(tokenId)) {
            revert TokenDoesNotExist(tokenId);
        }
        return tokenTraits[tokenId][traitName];
    }

    function getTraits(uint tokenId) public view returns (string[] memory) {
        if (!_exists(tokenId)) {revert TokenDoesNotExist(tokenId);}

        uint count;
        for (uint i = 0; i < traitList.length; i++) {
            if (tokenTraits[tokenId][traitList[i]]) {
                count++;
            }
        }

        string[] memory traits = new string[](count);
        uint index;
        for (uint i = 0; i < traitList.length; i++) {
            if (tokenTraits[tokenId][traitList[i]]) {
                traits[index] = traitList[i];
                index++;
            }
        }

        return traits;
    }

    function addTraitToSpawningStone(uint tokenId, string memory traitName, bool value) external onlyOwner {
        if (!_exists(tokenId)) {revert TokenDoesNotExist(tokenId);}
        if (!isValidTrait(traitName)) {revert TraitNotValid(traitName);}
        spawningStoneTraits[tokenId][traitName] = value;
        emit TraitAdded(tokenId, traitName, value);
    }

    function addGlobalTrait(string memory traitName) external onlyOwner {
        traitList.push(traitName);
        emit GlobalTraitAdded(traitName);
    }

    function addSouls(uint tokenID, uint amount) external onlyOwner {
        spawningStoneSouls[tokenID] += amount;
        uint newSoulsAmount = spawningStoneSouls[tokenID];
        emit SoulsAdded(tokenID, amount, newSoulsAmount);
    }

}
