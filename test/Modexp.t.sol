// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Modexp} from "src/Modexp.sol";

contract ModexpTest is Test {
    function check_Modexp(uint256 value, uint256 power) public view {
        uint256 f2 = Modexp.f2(value, power);
        uint256 f1 = Modexp.f1(value, power);
        assert(f1 == f2);
    }

    function test_Modexp(uint256 value, uint256 power) public view {
        check_Modexp(value, power);
    }
}
