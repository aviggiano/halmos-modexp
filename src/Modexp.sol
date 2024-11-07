// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

uint256 constant R_MOD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

library Modexp {
    function f1(uint256 v, uint256 p) internal view returns (uint256 r) {
        assembly {
            function revertWithMessage(len, reason) {
                // "Error(string)" signature: bytes32(bytes4(keccak256("Error(string)")))
                mstore(
                    0x00,
                    0x08c379a000000000000000000000000000000000000000000000000000000000
                )
                // Data offset
                mstore(
                    0x04,
                    0x0000000000000000000000000000000000000000000000000000000000000020
                )
                // Length of revert string
                mstore(0x24, len)
                // Revert reason
                mstore(0x44, reason)
                // Revert
                revert(0x00, 0x64)
            }
            function modexp(value, power) -> res {
                mstore(0x00, 0x20)
                mstore(0x20, 0x20)
                mstore(0x40, 0x20)
                mstore(0x60, value)
                mstore(0x80, power)
                mstore(0xa0, R_MOD)
                if iszero(staticcall(gas(), 5, 0, 0xc0, 0x00, 0x20)) {
                    revertWithMessage(24, "modexp precompile failed")
                }
                res := mload(0x00)
            }
            r := modexp(v, p)
        }
    }

    function f2(uint256 v, uint256 p) internal pure returns (uint256 r) {
        assembly {
            function modexp(value, power) -> res {
                res := 1
                for {

                } gt(power, 0) {

                } {
                    if mod(power, 2) {
                        res := mulmod(res, value, R_MOD)
                    }
                    value := mulmod(value, value, R_MOD)
                    power := shr(1, power)
                }
            }

            r := modexp(v, p)
        }
    }
}