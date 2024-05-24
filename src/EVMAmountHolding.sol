// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "AssertionLogic/src/AssertionLogic.sol";
import {DynamicAssertion, Identity, HttpHeader} from "./DynamicAssertion.sol";
import {EVMTokenType} from "./Types.sol";

contract EVMAmountHolding is DynamicAssertion {
    using AssertionLogic for AssertionLogic.CompositeCondition;

    AssertionLogic.CompositeCondition compositeCondition;

    uint256 min = 0;
    uint256 max = 0;

    function execute(Identity[] memory, string[] memory)
        public
        override
        returns (string memory, string memory, string[] memory, string memory, bool)
    {
        string memory description = "The amount of a particular token you are holding";
        string memory assertionType = "Token Holding Amount";
        string memory schemaUrl =
            "https://raw.githubusercontent.com/litentry/vc-jsonschema/main/dist/schemas/21-evm-holding-amount/1-1-0.json";

        updateAssertionLogic(EVMTokenType.Ton);

        return (description, assertionType, assertions, schemaUrl, true);
    }

    function updateAssertionLogic(EVMTokenType) public {
        compositeCondition.andOp("$token", AssertionLogic.Operator.Equal, Strings.toString(min));

        compositeCondition.andOp("$address", AssertionLogic.Operator.Equal, Strings.toString(min));
        compositeCondition.andOp("$network", AssertionLogic.Operator.Equal, Strings.toString(min));

        compositeCondition.andOp("$holding_amount", AssertionLogic.Operator.GreaterThanOrEqual, Strings.toString(min));
        compositeCondition.andOp("$holding_amount", AssertionLogic.Operator.LessThan, Strings.toString(max));

        // logic
        assertions.push(compositeCondition.toString());
    }

    function getEvmTokenBalance() public pure returns (int64) {
        return 3;
    }
}
