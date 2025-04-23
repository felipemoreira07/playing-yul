// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract ArrayMapping {
    uint256[3] public fixedArray;
    uint256[] public bigArray;
    uint8[] public smallArray; // variable packing

    mapping(uint256 => uint256) public simpleMapping;
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;
    mapping(address => uint256[]) public addressToList;

    constructor() {
        fixedArray = [661, 242, 333];
        bigArray = [4, 5, 6];
        smallArray = [7, 8, 9];

        simpleMapping[2] = 4;
        nestedMapping[3][4] = 12;
        addressToList[0x6160D0Ca6ad8AA9Cc68d143D01591d8050b7dD9f] = [
            11,
            22,
            33
        ];
    }

    // does not store the lenght, the first slot is the first item directly
    function getFixedArrayItemLength() external view returns (uint256 x) {
        assembly {
            x := sload(fixedArray.slot)
        }
    }

    function getFixedArrayItemByIndex(
        uint256 index
    ) external view returns (uint256 x) {
        assembly {
            x := sload(add(fixedArray.slot, index))
        }
    }

    function getBigArrayLength() external view returns (uint256 x) {
        assembly {
            x := sload(bigArray.slot)
        }
    }

    function getBigArrayItemByIndex(
        uint256 index
    ) external view returns (uint256 x) {
        uint256 slot;
        assembly {
            slot := bigArray.slot
        }
        // keccak256 works out of assembly code
        bytes32 location = keccak256(abi.encode(slot));
        assembly {
            x := sload(add(location, index))
        }
    }

    function getSmallArrayLength() external view returns (uint256 x) {
        assembly {
            x := sload(smallArray.slot)
        }
    }

    function getSmallArrayItemByIndex(
        uint256 index
    ) external view returns (bytes32 x) {
        uint256 slot;
        assembly {
            slot := smallArray.slot
        }
        // keccak256 works out of assembly code
        bytes32 location = keccak256(abi.encode(slot));
        assembly {
            x := sload(add(location, index))
        }
    }

    // does not work
    function getSimpleMappingLength() external view returns (uint256 x) {
        assembly {
            x := sload(simpleMapping.slot)
        }
    }

    function getSimpleMapping(uint256 key) external view returns (uint256 x) {
        uint256 slot;
        assembly {
            slot := simpleMapping.slot
        }
        // instead of index, takes the key of a value and it goes inside keccak256
        bytes32 location = keccak256(abi.encode(key, slot));
        assembly {
            x := sload(location)
        }
    }

    function getNestedMapping() external view returns (uint256 x) {
        uint256 slot;
        assembly {
            slot := nestedMapping.slot
        }
        // double encode and keccak256!!
        // looks at 3 (external) first and then at 4 (internal)
        bytes32 location = keccak256(
            abi.encode((4), keccak256(abi.encode(3, slot)))
        );
        assembly {
            x := sload(location)
        }
    }

    function getAddressToListLength() external view returns (uint256 x) {
        uint256 slot;
        assembly {
            slot := addressToList.slot
        }
        // simple keccak256 = length
        bytes32 location = keccak256(
            abi.encode(0x6160D0Ca6ad8AA9Cc68d143D01591d8050b7dD9f, slot)
        );
        assembly {
            x := sload(location)
        }
    }

    function getAddressToList(uint256 index) external view returns (uint256 x) {
        uint256 slot;
        assembly {
            slot := addressToList.slot
        }
        // double keccak256 = value by index
        bytes32 location = keccak256(
            abi.encode(
                keccak256(
                    abi.encode(0x6160D0Ca6ad8AA9Cc68d143D01591d8050b7dD9f, slot)
                )
            )
        );
        assembly {
            x := sload(add(location, index))
        }
    }
}
