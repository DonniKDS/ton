pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract CarsToken {
    
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    struct Token {
        string carModel;
        uint carWeight;
        uint carMaxSpeed;
        uint carPrice;
    }

    Token[] tokensArr;
    mapping (uint=>uint) tokensToOwners; // tokenId => owner
    mapping (uint=>uint) tokensOnSale;   // tokenId => tokenPrice

    modifier accept() {
        tvm.accept();
        _;
    }

    modifier checkOwner(uint tokenId) {
        require(tokensToOwners[tokenId] == msg.pubkey(), 104);
        _;
    }

    function createToken(string carModel, uint carWeight, uint carMaxSpeed, uint carPrice) public accept {
        if (!tokensArr.empty()) {
            for (uint i = 0; i < tokensArr.length; i++) {
                require(tokensArr[i].carModel != carModel, 103);
            }
        }

        tokensArr.push(Token(carModel, carWeight, carMaxSpeed, carPrice));
        uint keyAsLastNum = tokensArr.length - 1;
        tokensToOwners[keyAsLastNum] = msg.pubkey();
    }

    function putTokenForSale(uint tokenId, uint tokenPrice) public checkOwner(tokenId) accept {
        tokensOnSale[tokenId] = tokenPrice;
    }
}