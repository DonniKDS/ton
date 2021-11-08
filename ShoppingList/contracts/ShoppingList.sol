pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import '../structs/Purchase.sol';
import '../structs/PurchasesInfo.sol';
import '../interfaces/ShoppingListInterface.sol';

contract ShoppingList is ShoppingListInterface {

    uint256 m_ownerPubkey;
    uint32 purchaseCount;

    mapping(uint32 => Purchase) purchases;
    
    constructor( uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    modifier onlyOwner() {
        require(tvm.pubkey() != m_ownerPubkey, 101);
        _;
    }

    function createPurchase(string name, uint32 count) public override onlyOwner {
        tvm.accept();
        purchases[purchaseCount] = Purchase(purchaseCount, name, count, now, false, 0);
        purchaseCount++;
    }

    function deletePurchase(uint32 id) public override onlyOwner {
        require(purchases.exists(id), 102);
        tvm.accept();
        delete purchases[id];
    }

    function getPurchase() public view override returns (Purchase[] purchasesArray) {
        string name;
        uint32 count;
        uint32 time;
        bool isBuy;
        int price;

        for((uint32 id, Purchase purchase) : purchases) {
            name = purchase.name;
            count = purchase.count;
            time = purchase.time;
            isBuy = purchase.isBuy;
            price = purchase.price;
            purchasesArray.push(Purchase(id, name, count, time, isBuy, price));
       }
    }

    function getInfo() public view override returns (PurchasesInfo info) {
        uint32 purchasePaidCount;
        uint32 purchaseNotPaidCount;
        int totalPaidForAllTime;

        for((, Purchase purchase) : purchases) {
            if  (purchase.isBuy) {
                purchasePaidCount++;
                totalPaidForAllTime += purchase.price;
            } else {
                purchaseNotPaidCount++;
            }
        }
        info = PurchasesInfo(purchasePaidCount, purchaseNotPaidCount, totalPaidForAllTime);
    }

    function buy(uint32 id, int price) public override {
         purchases[id].isBuy = true;
         purchases[id].price = price;
    }
}