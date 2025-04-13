// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract Shiftting {
    uint8 public A = 22;
    uint16 public B = 16;
    uint32 public C = 1031212;
    uint128 public D = 4;

    function getOffsetA() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := A.slot
            offset := A.offset // bytes
        }
    }

    function getOffsetB() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := B.slot
            offset := B.offset // bytes
        }
    }

    function getOffsetC() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := C.slot
            offset := C.offset // bytes
        }
    }

    function getOffsetD() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := D.slot
            offset := D.offset // bytes
        }
    }

    function readBySlot(uint256 slot) external view returns (bytes32 a) {
        assembly {
            a := sload(slot)
        }
    }

    function readA() external view returns (uint256 a) {
        assembly {
            let value := sload(A.slot) // uint8 A
            // let shifted := shl(mul(A.offset, 8), value)
            // shl recebe o valor em bits (1 byte = 8 bits)
            a := and(0xff, value)
            // 1 'ff' - 1 byte
            // cada 'f' representa '11'
        }
    }

    function readB() external view returns (uint256 b) {
        assembly {
            let value := sload(B.slot) // uint16 B
            let shifted := shr(mul(B.offset, 8), value)
            b := and(0xffff, shifted)
        }
    }

    function readC() external view returns (uint256 c) {
        assembly {
            let value := sload(C.slot) // uint32 C
            let shifted := shr(mul(C.offset, 8), value)
            c := and(0xffffff, shifted)
        }
    }

    function readD() external view returns (uint256 d) {
        assembly {
            let value := sload(D.slot) // uint128 D
            let shifted := shr(mul(D.offset, 8), value)
            d := and(0xffffffffffffffffffffffffffffffff, shifted)
        }
    }
}
