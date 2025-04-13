// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract Basic {
    function representation() external pure returns (bool) {
        bool x;
        assembly {
            x := false
        }
        return x;
    }

    function isEven(uint256 num) external pure returns (bool) {
        bool r = false;
        assembly {
            if iszero(mod(num, 2)) {
                r := true
            }
        }
        return r;
    }

    function isPrime(uint256 num) external pure returns (bool) {
        bool r = true;
        assembly {
            let halfNum := add(div(num, 2), 1)
            for {
                let i := 2
            } lt(i, halfNum) {
                i := add(i, 1)
            } {
                if iszero(mod(num, i)) {
                    r := false
                }
            }
        }
        return r;
    }
}
