// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../src/LitStaking.sol";
import {Identity} from "../src/DynamicAssertion.sol";

contract TestLitStaking is Test {
    LitStacking staking;

    function testExecute() public {
        staking = new LitStacking();

        Identity[] memory identities;
        string[] memory secrets;
        (
            string memory description,
            string memory assertionType,
            string[] memory assertions,
            string memory schemaUrl,
            bool ret
        ) = staking.execute(identities, secrets);

        string memory expectedDescription = "The amount of LIT you are staking.";
        string memory expectedAssertionType = "LIT staking amount";
        string memory expectedSchemaUrl =
            "https://raw.githubusercontent.com/litentry/vc-jsonschema/main/dist/schemas/17-token-holding-amount/1-1-0.json";

        assertEq(description, expectedDescription);
        assertEq(assertionType, expectedAssertionType);
        assertEq(schemaUrl, expectedSchemaUrl);
        assertEq(assertions.length, 1);

        assert(ret);
    }
}
