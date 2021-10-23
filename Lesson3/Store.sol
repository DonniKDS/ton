
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Store {

    string[] queue;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
		_;
    }

    function getInLine(string name) public checkOwnerAndAccept {
        if (queue.empty()) {
            queue[0] = name;
        } else {
            queue[queue.length] = name;
        }
    }

    function outOfTheLine() public checkOwnerAndAccept {
        require(!queue.empty(), 110, "Queue is empty!");
        if (queue.length < 2) {
            delete queue[0];
        } else {
            for (uint i = 0; i < queue.length-1; i++) {
                queue[i] = queue[i+1];
            }
        }
    }
}
