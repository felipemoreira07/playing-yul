## memory part

memory is a temporary storage area for data that is not stored on the blockchain

you need memory in solidity when:

- return values to external calls (when an external contract calls your contract)
- set the function arguments for external calls (make an external call to another contract)
- get values from external calls
- revert with an error string
- log messages
- create other smart contracts
- use keccak256 hash function

memory is equivalent to heap in other languages, but does not has garbage collection or free command

memory is laid out in 32 byte sequences, like storage, but it's adressable by byte rather than increments of 32

only four important instructions: `mload`, `mstore`, `mstore8` and `msize`

it's easy to handle memory in pure yul programs, because it is just an array, but when yul mixes with solidity, solidity needs a special treatment with memory

it is true that is cheaper to access memory than storage, but the further you access memory on that long array, more and more charges of gas, until it becomes quadratic (this is to disincentivize user from abusing the memory in ethereum nodes)

- `mload(0xfffffffffffffff)`

commands:

- `mstore(p, v)`: stores value v in slot p (just like sstore)
- `mload(p)`: retrieves 32 bytes from slot p (e.g: `mload(0x20)`)
- `mstore8(p, v)`: like `mstore` but for 1 byte (there is `mload8()`)
- `msize()`: largest accessed memory index in that transaction

examples:

`mstore(0x00, 0xff..ff)` // 32 bytes value, it starts in byte 0x00 (0) and ends in 0x1f (31)
`mstore(0x01, 0xff..ff)` // 32 bytes value, it starts in byte 0x01 (1) and ends in 0x2f (32)
`mstore(0x00, 7)` // hexadecimal 7 == decimal 7 -> same of `mstore(0x00, 0x00..07)` -> will occupy 32 bytes with the 7 in the last place
`mstore8(0x00, 0x7)` // 07 in 0x00, first byte

there can be overwritten values if they are not cared

first command - `mstore8(0x00, 0x7)` // overwritten
second command - `mstore(0x00, 0x7)`
