pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'InitializationDebot.sol';

contract ListDebot is InitializationDebot {

    uint32 private idForBuy;

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
                MenuItem("Внести продукт в список покупок","",tvm.functionId(createPurchase)),
                MenuItem("Показать список покупок","",tvm.functionId(showPurchases)),
                MenuItem("Купить продукт из списка покупок", "", tvm.functionId(buyPurchase)),
                MenuItem("Удалить продукт из списка покупок","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function createPurchase(uint32 index) public {
        index = index;
        Terminal.input(tvm.functionId(createPurchase_), "В одну линии, пожалуйста:", false);
    }

    function createPurchase_(string name, uint32 count) public view {
        optional(uint256) pubkey = 0;
        ShoppingListInterface(shoppingAddress).createPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(name, count);
    }

    function showPurchases(uint32 index) public {
        index = index;
        optional(uint256) none;
        ShoppingListInterface(shoppingAddress).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showPurchases_),
            onErrorId: 0
        }();
    }

    function showPurchases_(Purchase[] purchases) public {
        uint32 i;
        if (purchases.length > 0 ) {
            Terminal.print(0, "Ваш список покупок:");
            for (i = 0; i < purchases.length; i++) {
                Purchase purchase = purchases[i];
                string completed;
                if (purchase.isBuy) {
                    completed = 'Купили';
                } else {
                    completed = 'Не купили';
                }
                Terminal.print(0, format("{} {}  \"{}\"  в количестве {} за {}", purchase.id, completed, purchase.name, purchase.count, purchase.price));
            }
        } else {
            Terminal.print(0, "Ваш список покупок пуст!");
        }
        _menu();
    }

    function buyPurchase(uint32 index) public {
        index = index;
        if (info.purchaseNotPaidCount > 0) {
            Terminal.input(tvm.functionId(buyPurchaseId_), "Введите номер продукта из списка продуктов:", false);
        } else {
            Terminal.print(0, "Извините, у вас нет продуктов в списке покупок, которые нужно купить");
            _menu();
        }
    }

    function buyPurchaseId_(string value) public {
        (uint256 num,) = stoi(value);
        idForBuy = uint32(num);
        Terminal.input(tvm.functionId(buyPurchase_), "Введите цену продукта:", false);
    }

    function buyPurchase_(string value) public {
        (uint num,) = stoi(value);
        optional(uint256) pubkey = 0;
        ShoppingListInterface(shoppingAddress).buy{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(idForBuy, num);
    }

    

    function deletePurchase(uint32 index) public {
        index = index;
        if (info.purchasePaidCount + info.purchaseNotPaidCount > 0) {
            Terminal.input(tvm.functionId(deletePurchase_), "Введите номер продукта из списка продуктов:", false);
        } else {
            Terminal.print(0, "Извините, у вас нет продуктов в списке покупок");
            _menu();
        }
    }

    function deletePurchase_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        ShoppingListInterface(shoppingAddress).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }
}