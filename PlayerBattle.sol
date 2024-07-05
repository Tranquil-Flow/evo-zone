pragma solidity 0.8.25;

// Import Monster.sol interface

contract PlayerBattle {

    uint totalBattles;

    struct Battles {
        uint battleID;
        uint monsterA_ID;
        uint monsterB_ID;
        uint winner;    // 0 = undeclared, 1 = monsterA_ID, 2 = monsterB_ID
    }

    Battles[] public battles;

    struct BattleOffers {
        uint monsterToBattle;
        uint deadline;
        bool offerAccepted;
    }

    mapping(uint => BattleOffers[]) public battleOfferList;

    event BattleOfferOpened(uint monsterInitiatingBattle, uint monsterReceivingBattleOffer, uint battleDeadline);
    event BattleOfferClosed(uint monsterInitiatingBattle, uint monsterReceivingBattleOffer);
    event BattleStarted(uint monsterA_ID, uint monsterB_ID, uint battleStartTime);
    event BattleFinished(uint monsterA_ID, uint monsterB_ID, uint battleFinishTime, uint winner);

    error NoBattleOffer;
    error BattleOfferExpired;
    error FightAlreadyAccepted;

    function openBattleOffer(uint _monsterToBattle, uint _offerLength) external {
        uint deadline = block.timestamp + _offerLength;
        battleOffers[msg.sender] = BattleOffers(_monsterToBattle, deadline, false);
        emit BattleOfferOpened(msg.sender, _monsterToBattle, deadline); 
    }

    function closeBattleOffer(uint _monsterToNotBattle) external {
        battleOffers[msg.sender] = BattleOffers(_monsterToNotBattle, 0, false);
        emit BattleOfferClosed(msg.sender, _monsterToNotBattle);
    }

    function acceptBattleOffer(uint monsterAcceptingOffer, uint monsterFighting) external {
        // Check that the owner of the monster is the one accepting offer

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

    function monsterBattle(uint monsterA_ID, uint monsterB_ID) public {
        IMonster monsterA = IMonster(address(monsterAContract));
        IMonster monsterB = IMonster(address(monsterBContract));

        (uint healthA, uint attackA, uint defenseA, uint speedA) = monsterA.getMonsterAttributes(monsterA_ID);
        (uint healthB, uint attackB, uint defenseB, uint speedB) = monsterB.getMonsterAttributes(monsterB_ID);

        uint currentHealthA = healthA;
        uint currentHealthB = healthB;

        while (currentHealthA > 0 && currentHealthB > 0) {
            if (speedA >= speedB) {
                // Monster A attacks first
                uint damage = attackA > defenseB ? attackA - defenseB : 0;
                currentHealthB = currentHealthB > damage ? currentHealthB - damage : 0;

                if (currentHealthB > 0) {
                    // Monster B counterattacks
                    damage = attackB > defenseA ? attackB - defenseA : 0;
                    currentHealthA = currentHealthA > damage ? currentHealthA - damage : 0;
                }
            } else {
                // Monster B attacks first
                uint damage = attackB > defenseA ? attackB - defenseA : 0;
                currentHealthA = currentHealthA > damage ? currentHealthA - damage : 0;

                if (currentHealthA > 0) {
                    // Monster A counterattacks
                    damage = attackA > defenseB ? attackA - defenseB : 0;
                    currentHealthB = currentHealthB > damage ? currentHealthB - damage : 0;
                }
            }
        }

        uint winner = currentHealthA > 0 ? 1 : 2;
        finishFight(monsterA_ID, monsterB_ID, winner);
    }

    function finishFight(uint _monsterA_ID, uint _monsterB_ID, uint _winner) public {
        battles.push(Battles(totalBattles, monsterA_ID, monsterB_ID, winner));
        emit BattleFinished(_monsterA_ID, _monsterB_ID, block.timestamp, _winner);
    }

}