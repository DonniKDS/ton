pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObjectInterface.sol';

contract GameObject is GameObjectInterface {

    int private health = 100;
    bool private destroyed = false;

    function takeTheAttack(int damage) external virtual override {
        tvm.accept();
        address a = msg.sender;
        setHealth(damage - getDefense());
        if (isDestroyed()) {
            destruction(a);
        }
    }

    function isDestroyed() private returns (bool) {
        tvm.accept();
        if (getHealth() <= 0) {
            destroyed = true;
        }
        return destroyed;
    }

    function destruction(address a) public virtual {
        tvm.accept();
        sendTransactionAndDestroy(a);
    }

    function sendTransactionAndDestroy(address a) internal virtual {
        tvm.accept();
        a.transfer(0, false, 160);
    }

    function getDefense() public virtual returns (int){
        tvm.accept();
        return 10;
    }

    function setHealth(int h) public {
        tvm.accept();
        health = h;
    }

    function getHealth() public returns (int){
        tvm.accept();
        return health;
    }
}