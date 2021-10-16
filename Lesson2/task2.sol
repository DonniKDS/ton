

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract task2 {
   
    uint32 public number = 1;

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

    function multiply(uint32 multiplier) public checkOwnerAndAccept {
        require(multiplier >= 1, 103, "Множитель должен быть от 1 до 10 включительно");
        require(multiplier <= 10, 104, "Множитель должен быть от 1 до 10 включительно");
        number = number * multiplier;
    }
}
