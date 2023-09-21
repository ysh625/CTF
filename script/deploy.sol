// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
//import "../ctf/greeterGate/contracts/greeterGate.sol";
import "../ctf/greeterGate/contracts/greeterGate.sol";

contract Deploy is Script {
    uint256 public deployerPrivateKey;
    address public deployerEoa;

    function setUp() public {
        deployerPrivateKey = vm.envUint("ANVIL_PRIVATE_KEY");
        //MAINNET_RPC=vm.envString("PRIVATE_KEY");
        deployerEoa = vm.rememberKey(deployerPrivateKey);
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);
        bytes32 data0 = 0x74656ab000000000000000000000000000000000000000000000000000000000;
        bytes32 data1 = 0x765a416000000000000000000000000000000000000000000000000000000000;
        bytes32 data2 = 0x7685467000000000000000000000000000000000000000000000000000000000;
        Gate gate = new Gate(data0, data1, data2);

        vm.stopBroadcast();
    }
}
