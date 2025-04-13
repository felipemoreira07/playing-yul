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
            // shl receives the value in bits (1 byte = 8 bits)
            a := and(0xff, value)
            // 1 'ff' - 1 byte
            // each 'f' represents '11'
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

    // write logic: clears old value, bitshift new value and add it to the cleared spot in slot

    function writeA(uint8 newA) external {
        assembly {
            // sstore(A.slot, newA) // impossible, will overwrite the other variables in the slot
            // never do in production

            // + V and 00 == 00 (clears value)
            // + V and FF == V  (mantain value)
            // + V or  00 == V  (write new value)

            // yul only understands bytes32
            // newA = 0x0000000000000000000000000000000000000000000000000000000000000005 (e.g)
            let a := sload(A.slot)
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000201
            let slotWithoutA := and(
                a,
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
            )
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000200
            let slotWithNewA := or(slotWithoutA, newA)
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000205
            sstore(A.slot, slotWithNewA)
        }
    }

    function writeB(uint16 newB) external {
        assembly {
            // newB = 0x0000000000000000000000000000000000000000000000000000000000000006 (e.g)
            let b := sload(B.slot)
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000201
            let slotWithoutB := and(
                b,
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000ff
            )
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000001
            let shiftedNewB := shl(mul(B.offset, 8), newB)
            let slotWithNewB := or(slotWithoutB, shiftedNewB)
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000601
            sstore(B.slot, slotWithNewB)
        }
    }

    function writeC(uint32 newC) external {
        assembly {
            // newC = 0x0000000000000000000000000000000000000000000000000000000000000007 (e.g)
            let c := sload(C.slot)
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000201
            let slotWithoutC := and(
                c,
                0xffffffffffffffffffffffffffffffffffffffffffffffffff00000000ffffff
            )
            // slot = 0x0000000000000000000000000000000000000000000000000400000000000201
            let shiftedNewC := shl(mul(C.offset, 8), newC)
            let slotWithNewC := or(slotWithoutC, shiftedNewC)
            // slot = 0x0000000000000000000000000000000000000000000000000400000007000201
            sstore(C.slot, slotWithNewC)
        }
    }

    function writeD(uint128 newD) external {
        assembly {
            // newD = 0x0000000000000000000000000000000000000000000000000000000000000008 (e.g)
            let d := sload(D.slot)
            // slot = 0x0000000000000000000000000000000000000000000000000400000003000201
            let slotWithoutD := and(
                d,
                0xffffffffffffffffff00000000000000000000000000000000ffffffffffffff
            )
            // slot = 0x0000000000000000000000000000000000000000000000000000000003000001
            let shiftedNewD := shl(mul(D.offset, 8), newD)
            let slotWithNewD := or(slotWithoutD, shiftedNewD)
            // slot = 0x0000000000000000000000000000000000000000000000000800000003000601
            sstore(D.slot, slotWithNewD)
        }
    }
}
