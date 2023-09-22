// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../ctf/greeterGate/contracts/greeterGate.sol";

contract GateTest is Test {
    Gate public gate;
    bytes32 public data0 =
        0x74656ab000000000000000000000000000000000000000000000000000000000;
    bytes32 public data1 =
        0x765a416000000000000000000000000000000000000000000000000000000000;
    bytes32 public data2 =
        0x7685467000000000000000000000000000000000000000000000000000000000;

    function setUp() public {
        gate = new Gate(data0, data1, data2);
    }

    function handle() internal {
        bytes32 data = data2;
        gate.resolve(abi.encodeWithSignature("unlock(bytes)", data));
        console.log("isSolved: %s", gate.isSolved());
    }

    function testResolved() public {
        handle();
        assertEq(gate.isSolved(), true);
    }
}
