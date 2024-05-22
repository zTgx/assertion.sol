// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "AssertionLogic/src/AssertionLogic.sol";
import {DynamicAssertion, Identity, HttpHeader} from "./DynamicAssertion.sol";
import "./IAssertionBaseInfo.sol";

contract LitStacking is DynamicAssertion, IAssertionBaseInfo {
    using AssertionLogic for AssertionLogic.CompositeCondition;

    AssertionLogic.CompositeCondition compositeCondition;

    uint256 min = 0;
    uint256 max = 0;

    /**
     * Returns: (from left to right in order)
     *     AssertionDescription/AssertionType/Assertion codes/AssertionSchemaUrl/AssertionResult
     */
    function execute(Identity[] memory identities, string[] memory)
        public
        override
        returns (string memory, string memory, string[] memory, string memory, bool)
    {
        // request lit staking amount
        uint256 amount = requestLitStakingAmount(identities);

        // min and max
        updateMinAndMax(amount);

        // logic
        assertions.push(this.logic());

        return (this.description(), this.assertionType(), assertions, this.schemaUrl(), true);
    }

    /**
     * Impl IAssertionBaseInfo callbacks
     */
    function description() external pure returns (string memory) {
        return "The amount of LIT you are staking.";
    }

    function assertionType() external pure returns (string memory) {
        return "LIT staking amount";
    }

    function schemaUrl() external pure returns (string memory) {
        return
        "https://raw.githubusercontent.com/litentry/vc-jsonschema/main/dist/schemas/17-token-holding-amount/1-1-0.json";
    }

    function logic() external returns (string memory) {
        compositeCondition.andOp("$lit_staking_amount", AssertionLogic.Operator.GreaterThan, Strings.toString(min));
        compositeCondition.andOp("$lit_staking_amount", AssertionLogic.Operator.LessThanOrEqual, Strings.toString(max));

        return compositeCondition.toString();
    }

    // Hardcode NOW. Waiting POST method
    function requestLitStakingAmount(Identity[] memory) private pure returns (uint256) {
        return 35;
    }

    function updateMinAndMax(uint256 sum) private {
        if (sum >= 0 && sum <= 1) {
            min = 0;
            max = 1;
        } else if (sum > 1 && sum <= 50) {
            min = 1;
            max = 50;
        } else if (sum > 50 && sum <= 100) {
            min = 50;
            max = 100;
        } else if (sum > 100 && sum <= 200) {
            min = 100;
            max = 200;
        } else if (sum > 200 && sum <= 500) {
            min = 200;
            max = 500;
        } else if (sum > 500 && sum <= 800) {
            min = 500;
            max = 800;
        } else if (sum > 800 && sum <= 1200) {
            min = 800;
            max = 1200;
        } else if (sum > 1200 && sum <= 1600) {
            min = 1200;
            max = 1600;
        } else if (sum > 1600 && sum <= 3000) {
            min = 1600;
            max = 3000;
        } else if (sum > 3000) {
            min = 3000;
            max = 9223372036854775807;
        }
    }
}
