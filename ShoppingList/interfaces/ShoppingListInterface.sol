pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import '../structs/Purchase.sol';
import '../structs/PurchasesInfo.sol';

interface ShoppingListInterface {
    function createPurchase(string name, uint32 count) external;
    function deletePurchase(uint32 id) external;
    function getPurchases() external view returns (Purchase[] purchasesArray);
    function getInfo() external view returns (PurchasesInfo info);
    function buy(uint32 id, uint price) external;
}