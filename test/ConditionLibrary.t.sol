// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../src/ConditionLibrary.sol";

contract TestConditionLibrary is Test {
    using ConditionLibrary for ConditionLibrary.CompositeCondition;

    ConditionLibrary.CompositeCondition public compositeCondition;

    function testAndOp() public {
        // Add conditions using 'andOp' operation
        compositeCondition.andOp("age", ConditionLibrary.Operator.GreaterThanOrEqual, "18");
        compositeCondition.andOp("score", ConditionLibrary.Operator.LessThanOrEqual, "100");

        // Serialize the composite condition
        string memory serialized = compositeCondition.toString();

        // Define the expected serialized output for 'And' operation
        string memory expectedSerialized =
            '{ "and": [ { "src": "age", "op": ">=", "dst": "18" }, { "src": "score", "op": "<=", "dst": "100" } ] }';

        StringHelper stringHelper = new StringHelper();
        string memory trimmedString = stringHelper.removeWhitespace(expectedSerialized);

        // Assert that the serialized output matches the expected format for 'Or' operation
        assertEq(serialized, trimmedString, "Serialized output does not match expected format (Or)");
    }

    function testOrOp() public {
        // Add conditions using 'orOp' operation
        compositeCondition.orOp("name", ConditionLibrary.Operator.Equal, "Alice");
        compositeCondition.orOp("name", ConditionLibrary.Operator.Equal, "Bob");

        // Serialize the composite condition
        string memory serialized = compositeCondition.toString();

        // Define the expected serialized output for 'Or' operation
        string memory expectedSerialized =
            '{ "or": [ { "src": "name", "op": "==", "dst": "Alice" }, { "src": "name", "op": "==", "dst": "Bob" } ] }';

        StringHelper stringHelper = new StringHelper();
        string memory trimmedString = stringHelper.removeWhitespace(expectedSerialized);

        // Assert that the serialized output matches the expected format for 'Or' operation
        assertEq(serialized, trimmedString, "Serialized output does not match expected format (Or)");
    }

    function testAndOp2() public {
        compositeCondition.andOp("$has_web2_account", ConditionLibrary.Operator.Equal, "true");
        compositeCondition.andOp("$has_web3_account", ConditionLibrary.Operator.Equal, "true");
        string memory serialized = compositeCondition.toString();

        string memory expectedSerialized =
            '{"and": [{ "src": "$has_web2_account", "op": "==", "dst": "true" }, { "src": "$has_web3_account", "op": "==", "dst": "true" } ] }';

        StringHelper stringHelper = new StringHelper();
        string memory trimmedString = stringHelper.removeWhitespace(expectedSerialized);

        // Assert that the serialized output matches the expected format for 'Or' operation
        assertEq(serialized, trimmedString, "Serialized output does not match expected format (Or)");
    }
}
