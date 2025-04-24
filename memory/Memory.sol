// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract Memory {
    // transaction cost too high, exceeds 3 million block limit
    // it grows exponentially with the number of bytes
    function highAccess() external pure {
        assembly {
            pop(mload(0xffffffff))
        }
    }
}
