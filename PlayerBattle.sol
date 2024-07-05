pragma solidity 0.8.25;

// Import Monster.sol interface

contract PlayerBattle {

    uint totalBattles;

    struct Battles {
        uint battleID;
        address monsterA;
        address monsterB;
        uint winner;    // 0 = undeclared, 1 = monsterA, 2 = monsterB
    }

    Battles[] public battles;

    struct BattleOffers {
        address monsterToBattle;
        uint deadline;
        bool offerAccepted;
    }

    mapping(address => BattleOffers[]) public battleOfferList;

    event BattleOfferOpened(address monsterInitiatingBattle, address monsterReceivingBattleOffer, uint battleDeadline);
    event BattleOfferClosed(address monsterInitiatingBattle, address monsterReceivingBattleOffer);
    event BattleStarted(address monsterA, address monsterB, uint battleStartTime);
    event BattleFinished(address monsterA, address monsterB, uint battleFinishTime, address winner);

    error NoBattleOffer;
    error BattleOfferExpired;
    error FightAlreadyAccepted;

    function openBattleOffer(address _monsterToBattle, uint _offerLength) external {
        uint deadline = block.timestamp + _offerLength;
        battleOffers[msg.sender] = BattleOffers(_monsterToBattle, deadline, false);
        emit BattleOfferOpened(msg.sender, _monsterToBattle, deadline); 
    }

    function closeBattleOffer(address _monsterToNotBattle) external {
        battleOffers[msg.sender] = BattleOffers(_monsterToNotBattle, 0, false);
        emit BattleOfferClosed(msg.sender, _monsterToNotBattle);
    }

    function acceptBattleOffer(address monsterFighting) external {
        address monsterAcceptingOffer = msg.sender;
        if (battleOfferList[monsterFighting].monsterToBattle != monsterAcceptingOffer) {
            revert NoBattleOffer();
        }
        if (battleOfferList[monsterFighting].deadline < block.timestamp) {
            revert BattleOfferExpired();
        }
        if (battleOfferList[monster.fighting].offerAccepted = true) {
            revert FightAlreadyAccepted();
        }
        
        uint _battleID = totalBattles++;

        battles.push(Battles(_battleID, monsterFighting, monsterAcceptingOffer, 0));
        emit BattleStarted(monsterFighting, monsterAcceptingOffer, block.timestamp);
    }

    function monsterBattle(address _monsterA, address _monsterB) public {
        // load monsterA's interface
        // load monsterB's interface

    }

    function finishFight(address _monsterA, address _monsterB, address _winner) public {
        // push info to battles
        emit BattleFinished(_monsterA, _monsterB, block.timestamp, _winner);
    }

}