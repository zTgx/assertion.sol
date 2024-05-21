// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.8;

library AssertionLogic {
    enum Operator {
        GreaterThan,
        LessThan,
        GreaterThanOrEqual,
        LessThanOrEqual,
        Equal,
        NotEq
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

    function andOp(CompositeCondition storage cc, string memory src, Operator op, string memory dst)
        internal
        returns (CompositeCondition storage)
    {
        addCondition(cc, src, op, dst);
        cc.isAnd = true;
        return cc;
    }

    function orOp(CompositeCondition storage cc, string memory src, Operator op, string memory dst)
        internal
        returns (CompositeCondition storage)
    {
        addCondition(cc, src, op, dst);
        cc.isAnd = false;
        return cc;
    }

    function toString(CompositeCondition memory cc) public pure returns (string memory) {
        string memory result = "{";

        if (cc.conditions.length > 0) {
            result = string(abi.encodePacked(result, cc.isAnd ? "\"and\":[" : "\"or\":["));
            for (uint256 i = 0; i < cc.conditions.length; i++) {
                if (i > 0) {
                    result = string(abi.encodePacked(result, ","));
                }
                result = string(
                    abi.encodePacked(
                        result,
                        '{"src":"',
                        cc.conditions[i].src,
                        '","op":"',
                        operatorToString(cc.conditions[i].op),
                        '","dst":"',
                        cc.conditions[i].dst,
                        '"}'
                    )
                );
            }
            result = string(abi.encodePacked(result, "]"));
        }

        result = string(abi.encodePacked(result, "}"));

        return result;
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
        } else if (op == Operator.NotEq) {
            return "!=";
        }
        // Handle other operators if needed
        revert("Unsupported operator");
    }
}
