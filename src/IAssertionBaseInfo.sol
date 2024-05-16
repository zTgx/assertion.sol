// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface IAssertionBaseInfo {
    function description() external returns (string memory);
    function assertionType() external returns (string memory);
    function schemaUrl() external returns (string memory);
}
