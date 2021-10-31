pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
    
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    function sendTransactionWithCommissionPay(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 1);
    }

    function sendTransactionWithoutCommissionPay(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 0);
    }

    function sendTrasactionAndDestroyTheWallet(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, false, 160);
    }
}