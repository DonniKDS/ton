pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'MilitaryUnit.sol';

contract Archer is MilitaryUnit {

    constructor(BaseStation base) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        setHealth(50);
        baseAddress = msg.sender;
        myBase = base;
        base.addUnit(this);
    }

    function getAttackPower() public override returns (int) {
        tvm.accept();
        return 12;
    }

    function getDefense() public override returns (int) {
        tvm.accept();
        return 3;
    }
}