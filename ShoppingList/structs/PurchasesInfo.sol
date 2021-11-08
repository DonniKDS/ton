pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

struct PurchasesInfo {
    uint32 purchasePaidCount;
    uint32 purchaseNotPaidCount;
    int totalPaidForAllTime;
}