// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

library ConditionLibrary {
    enum Operator {
        Equal,
        GreaterThan,
        LessThan,
        GreaterThanOrEqual,
        LessThanOrEqual
    }
    // Add more operators as needed

    struct Condition {
        string src;
        Operator op;
        string dst;
    }

    function addCondition(Condition[] storage conditions, string memory src, Operator op, string memory dst) public {
        Condition memory newCondition = Condition(src, op, dst);
        conditions.push(newCondition);
    }

    function toString(Condition[] storage conditions) public view returns (string memory) {
        string memory result = '{"and": [';
        for (uint256 i = 0; i < conditions.length; i++) {
            if (i > 0) {
                result = string(abi.encodePacked(result, ", "));
            }
            result = string(
                abi.encodePacked(
                    result,
                    '{ "src": "',
                    conditions[i].src,
                    '", "op": "',
                    operatorToString(conditions[i].op),
                    '", "dst": "',
                    conditions[i].dst,
                    '" }'
                )
            );
        }
        result = string(abi.encodePacked(result, " ] }"));
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
        }
        // Handle other operators if needed
        revert("Unsupported operator");
    }
}
