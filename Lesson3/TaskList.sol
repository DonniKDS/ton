pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    struct task {
        string taskName;
        uint32 timestamp;
        bool isDone;
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    uint8 tasksLength = 0;
    uint8 key = 0;
    mapping (uint8=>task) tasks;

    function addTask(string taskName) public {
        tasks[key] = task(taskName, now, false);
        tasksLength++;
        key++;
    }

    function openTasks() public view returns (uint8) {
        uint8 numberOfOpenTasks = 0;
        for(uint8 i = 0; i < tasksLength; i++) {
            if (tasks[i].isDone == false) {
                numberOfOpenTasks++;
            }
        }
        return numberOfOpenTasks;
    }

    function getTasks() public view returns (mapping (uint8=>task)) {
        return tasks;
    }

    function getTask(uint8 key) public view returns (task) {
        return tasks[key];
    }

    function deleteTask(uint8 key) public checkOwnerAndAccept {
        delete tasks[key];
        tasksLength--;
    }

    function taskIsDone(uint8 key) public checkOwnerAndAccept {
        tasks[key].isDone = true;
    }
}
