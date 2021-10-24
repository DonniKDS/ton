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
        int carWeight;
        int carMaxSpeed;
        int carPrice;
    }

    struct TokenWrapper {
        Token token;
        int price;
        bool isSale;
    }

    Token[] tokensArr;
    TokenWrapper[] tokenWrappersArr;
    mapping (uint=>uint) tokensToOwners; // tokenId => owner

    modifier accept() {
        tvm.accept();
        _;
    }

    modifier checkOwner(uint tokenId) {
        require(tokensToOwners[tokenId] == msg.pubkey(), 104);
        _;
    }

    function createToken(string carModel, int carWeight, int carMaxSpeed, int carPrice) public accept {
        if (!tokensArr.empty()) {
            for (uint i = 0; i < tokensArr.length; i++) {
                require(tokensArr[i].carModel != carModel, 103);
            }
        }

        Token token = Token(carModel, carWeight, carMaxSpeed, carPrice);
        tokensArr.push(token);
        tokenWrappersArr.push(TokenWrapper(token, -1, false));
        uint keyAsLastNum = tokensArr.length - 1;
        tokensToOwners[keyAsLastNum] = msg.pubkey();
    }

    function putTokenForSale(uint tokenId, int tokenPrice) public checkOwner(tokenId) accept {
        tokenWrappersArr[tokenId].price = tokenPrice;
        tokenWrappersArr[tokenId].isSale = true;
    }

    function tokenOnSaleInfo(uint tokenId) public view returns(string carModel, int carWeight, int carMaxSpeed, int carPrice, int price) {
        carModel = tokensArr[tokenId].carModel;
        carWeight = tokensArr[tokenId].carWeight;
        carMaxSpeed = tokensArr[tokenId].carMaxSpeed;
        carPrice = tokensArr[tokenId].carPrice;
        if (tokenWrappersArr[tokenId].isSale) {
            price = tokenWrappersArr[tokenId].price;
        }
    }
}