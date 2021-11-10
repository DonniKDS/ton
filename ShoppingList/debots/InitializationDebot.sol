pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import '../base/AddressInput.sol';
import '../base/Debot.sol';
import '../interfaces/Transactable.sol';
import '../structs/PurchasesInfo.sol';
import '../base/Terminal.sol';
import '../base/Sdk.sol';
import '../contracts/HasConstructorWithPubKey.sol';
import '../base/Menu.sol';
import '../interfaces/ShoppingListInterface.sol';

abstract contract InitializationDebot is Debot {
    bytes debotIcon;

    TvmCell shoppingCode;
    address shoppingAddress;
    PurchasesInfo info;
    uint32 purchaseId;
    uint256 userPubKey;
    address msigAddress;

    uint32 INITIAL_BALANCE =  200000000;

    function start() public override {
        Terminal.input(tvm.functionId(savePublicKey),"Введите ваш открытый ключ",false);
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Shopping List";
        version = "0.2.0";
        publisher = "TON Labs";
        key = "Shopping list manager";
        author = "DonniKDS";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a Shopping List DeBot.";
        language = "ru";
        dabi = m_debotAbi.get();
        icon = debotIcon;
    }

    function setTodoCode(TvmCell code) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        shoppingCode = code;
    }

    function savePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status) {
            userPubKey = res;
            Terminal.print(0, "Проверка, есть ли у вас уже список покупок ...");
            TvmCell deployState = tvm.insertPubkey(shoppingCode, userPubKey);
            shoppingAddress = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: адрес вашего контракта со списком покупок -> {}", shoppingAddress));
            Sdk.getAccountType(tvm.functionId(checkStatus), shoppingAddress);
        } else {
            Terminal.input(tvm.functionId(savePublicKey),"Неверный открытый ключ. Попробуйте снова!\nВведите ваш открытый ключ",false);
        }
    }

    function checkStatus(int8 acc_type) public {
        if (acc_type == 1) {
            _getInfo(tvm.functionId(setInfo));
        } else if (acc_type == -1)  {
            Terminal.print(0, "У вас еще нет списка покупок, поэтому будет создан новый, с начальным балансом 0.2 кристалла");
            AddressInput.get(tvm.functionId(creditAccount),"Выберите кошелек для оплаты. Мы попросим вас подписать две транзакции");
        } else  if (acc_type == 0) {
            Terminal.print(0, format(
                "Развертывание нового контракта. В случае возникновения ошибки проверьте, достаночно ли кристаллов на балансе вашего контракта со списком покупок"
            ));
            deploy();
        } else if (acc_type == 2) {
            Terminal.print(0, format("Невозможно продолжить: аккаунт {} заблокирован", shoppingAddress));
        }
    }

    function checkIfStatusIs0(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitBeforeDeploy();
        }
    }

    function setInfo(PurchasesInfo i) public virtual {
        info = i;
        _menu();
    }

    function _getInfo(uint32 answerId) internal virtual view {
        optional(uint256) none;
        ShoppingListInterface(shoppingAddress).getInfo{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }

    function creditAccount(address value) public {
        msigAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        Transactable(msigAddress).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit)
        }(shoppingAddress, INITIAL_BALANCE, false, 3, empty);
    }

    function deploy() internal view {
            TvmCell image = tvm.insertPubkey(shoppingCode, userPubKey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: shoppingAddress,
                callbackId: tvm.functionId(onSuccess),
                onErrorId:  tvm.functionId(onErrorRepeatDeploy),
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {HasConstructorWithPubKey, userPubKey}
            });
            tvm.sendrawmsg(deployMsg, 1);
    }

    function waitBeforeDeploy() public {
        Sdk.getAccountType(tvm.functionId(checkIfStatusIs0), shoppingAddress);
    }

    function onSuccess() public view {
        _getInfo(tvm.functionId(setInfo));
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

    function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public view {
        deploy();
    }

    function onErrorRepeatCredit(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        creditAccount(msigAddress);
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [Terminal.ID, Menu.ID, AddressInput.ID];
    }

    function _menu() internal virtual;
}