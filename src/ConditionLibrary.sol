// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./Helpers.sol";

library ConditionLibrary {
    enum Operator {
        Equal,
        GreaterThan,
        LessThan,
        GreaterThanOrEqual,
        LessThanOrEqual
        // Add more operators as needed
    }

    struct Condition {
        string src;
        Operator op;
        string dst;
    }

    struct CompositeCondition {
        Condition[] conditions;
        bool isAnd; // true for 'And', false for 'Or'
    }

    function addCondition(CompositeCondition storage cc, string memory src, Operator op, string memory dst) internal {
        cc.conditions.push(Condition(src, op, dst));
    }

    function andOp(CompositeCondition storage cc, string memory src, Operator op, string memory dst) internal returns (CompositeCondition storage) {
        addCondition(cc, src, op, dst);
        cc.isAnd = true;
        return cc;
    }

    function orOp(CompositeCondition storage cc, string memory src, Operator op, string memory dst) internal returns (CompositeCondition storage) {
        addCondition(cc, src, op, dst);
        cc.isAnd = false;
        return cc;
    }

    function serializeConditions(CompositeCondition memory cc) public returns (string memory) {
        string memory result = '{';

        if (cc.conditions.length > 0) {
            result = string(abi.encodePacked(result, cc.isAnd ? "\"and\": [" : "\"or\": ["));
            for (uint256 i = 0; i < cc.conditions.length; i++) {
                if (i > 0) {
                    result = string(abi.encodePacked(result, ", "));
                }
                result = string(abi.encodePacked(result, '{ "src": "', cc.conditions[i].src, '", "op": "', operatorToString(cc.conditions[i].op), '", "dst": "', cc.conditions[i].dst, '" }'));
            }
            result = string(abi.encodePacked(result, ']'));
        }

        result = string(abi.encodePacked(result, ' }'));

        StringHelper stringHelper = new StringHelper();
        string memory trimmedString = stringHelper.removeWhitespace(result);

        return trimmedString;
    }

    function operatorToString(Operator op) internal pure returns (string memory) {
        if (op == Operator.Equal) {
            return "==";
        } else if (op == Operator.GreaterThan) {
            return ">";
        } else if (op == Operator.LessThan) {
            return "<";
        } else if (op == Operator.GreaterThanOrEqual) {
            return ">=";
        } else if (op == Operator.LessThanOrEqual) {
            return "<=";
        }
        // Handle other operators if needed
        revert("Unsupported operator");
    }
}
