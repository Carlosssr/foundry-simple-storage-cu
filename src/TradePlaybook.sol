// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract TradePlaybook {
    error NotOwner();
    error EmptySetupName();

    event RuleUpdated(uint256 indexed previousRule, uint256 indexed newRule, address indexed updatedBy);
    event SetupLogged(string setupName, uint256 score, address indexed loggedBy);

    address public immutable owner;
    uint256 private activeRule;

    struct Setup {
        uint256 score;
        string name;
    }

    Setup[] public setups;
    mapping(string => uint256) public scoreBySetupName;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function getActiveRule() external view returns (uint256) {
        return activeRule;
    }

    function getSetupCount() external view returns (uint256) {
        return setups.length;
    }

    function setActiveRule(uint256 newRule) external onlyOwner {
        uint256 previous = activeRule;
        activeRule = newRule;
        emit RuleUpdated(previous, newRule, msg.sender);
    }

    function logSetup(string calldata setupName, uint256 score) external {
        if (bytes(setupName).length == 0) revert EmptySetupName();

        setups.push(Setup({score: score, name: setupName}));
        scoreBySetupName[setupName] = score;

        emit SetupLogged(setupName, score, msg.sender);
    }
}
