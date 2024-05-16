// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../src/ConditionLibrary.sol";

contract TestConditionLibrary is Test {
    using ConditionLibrary for ConditionLibrary.Condition[];

    ConditionLibrary.Condition[] conditions;

    function testAddConditionAndSerialize() public {
        // Add test conditions
        conditions.addCondition("age", ConditionLibrary.Operator.GreaterThanOrEqual, "18");
        conditions.addCondition("score", ConditionLibrary.Operator.LessThanOrEqual, "100");

        // Serialize conditions
        string memory serialized = conditions.toString();

        // Define expected serialized output
        string memory expectedSerialized =
            '{"and": [{ "src": "age", "op": ">=", "dst": "18" }, { "src": "score", "op": "<=", "dst": "100" } ] }';

        // Assert that the serialized output matches the expected JSON-like format
        assertEq(serialized, expectedSerialized, "Serialized output does not match expected format");
    }
}
