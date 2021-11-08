pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';

contract BaseStation is GameObject {

    GameObject[] units;
    mapping (GameObject => address) unitsMap;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function getDefense() public override returns (int){
        tvm.accept();
        return 10;
    }

    function addUnit(GameObject unit) public {
        tvm.accept();
        units[units.length] = unit;
        unitsMap[unit] = msg.sender;
    }

    function deleteUnit(GameObject unit) public {
        tvm.accept();
        delete unitsMap[unit];
    }

    function destruction(address a) public override {
        tvm.accept();
        for (uint i = 0; i < units.length; i++) {
            units[i].destruction(a);
        }
        sendTransactionAndDestroy(a);
    }
}