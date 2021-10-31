pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';
import 'BaseStation.sol';

contract MilitaryUnit is GameObject {

    address public baseAddress;
    BaseStation public myBase;

    function attack(GameObjectInterface target) public {
        target.takeTheAttack(getAttackPower());
    }

    function getAttackPower() public virtual returns (int) {
        tvm.accept();
        return 10;
    }

    function getDefense() public virtual override returns (int) {
        tvm.accept();
        return 5;
    }

    function destruction(address a) public override {
        require(msg.sender == baseAddress);
        tvm.accept();
        myBase.deleteUnit(this);
    }
}