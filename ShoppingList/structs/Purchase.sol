pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

struct Purchase {
    uint32 id;
    string name;
    uint32 count;
    uint32 time;
    bool isBuy;
    int price;
}