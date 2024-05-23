// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../src/utils/Helpers.sol";

contract TestStringHelper is Test {
    StringHelper stringHelper;

    // Test case to verify removing whitespace from a string
    function testRemoveWhitespace() public {
        stringHelper = new StringHelper();

        // Input string with whitespace
        string memory inputString = "   Hello  world!\n\t ";

        // Expected result after removing whitespace
        string memory expectedString = "Helloworld!";

        // Call the removeWhitespace function
        string memory trimmedString = stringHelper.removeWhitespace(inputString);

        // Assert that the trimmedString matches the expectedString
        assertEq(trimmedString, expectedString);
    }
}
