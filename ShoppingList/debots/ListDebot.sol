pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'InitializationDebot.sol';

contract ListDebot is InitializationDebot {

    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (todo/done/total) tasks. Total paid for all time {}",
                    info.purchasePaidCount,
                    info.purchaseNotPaidCount,
                    info.purchasePaidCount + info.purchaseNotPaidCount,
                    info.totalPaidForAllTime
            ),
            sep,
            [
                MenuItem("Create new task","",tvm.functionId(createPurchase)),
                MenuItem("Show task list","",tvm.functionId(showPurchases)),
                MenuItem("Update task status","",tvm.functionId(updatePurchase)),
                MenuItem("Delete task","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function createPurchase() public {

    }

    function showPurchases() public {

    }

    function updatePurchase() public {

    }

    function deletePurchase() public {

    }
}