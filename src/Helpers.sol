// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract StringHelper {
    // Function to remove all whitespace characters from a string
    function removeWhitespace(string memory input) public pure returns (string memory) {
        bytes memory inputBytes = bytes(input);
        uint256 resultLength = 0;
        bytes memory resultBytes = new bytes(inputBytes.length);

        for (uint256 i = 0; i < inputBytes.length; i++) {
            // Check if the current character is not a whitespace (space, tab, newline, etc.)
            if (!isWhitespace(inputBytes[i])) {
                resultBytes[resultLength] = inputBytes[i];
                resultLength++;
            }
        }

        // Create a new string from the result bytes array
        bytes memory trimmedBytes = new bytes(resultLength);
        for (uint256 j = 0; j < resultLength; j++) {
            trimmedBytes[j] = resultBytes[j];
        }

        return string(trimmedBytes);
    }

    // Internal function to check if a given byte represents a whitespace character
    function isWhitespace(bytes1 char) internal pure returns (bool) {
        if (
            char == bytes1(" ") // Space
                || char == bytes1("\t") // Tab
                || char == bytes1("\n") // Newline
                || char == bytes1("\r")
        ) {
            return true;
        }
        return false;
    }
}
