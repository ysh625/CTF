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
        Gate gate = Gate(0x4Eeb8b0D3B591EF856d6e85EeD9B9B72fA990f02);
        bytes memory data=bytes(0x7685467000000000000000000000000000000000000000000000000000000000);
        gate.resolve(abi.encodeWithSignature("unlock(bytes)", data));

        vm.stopBroadcast();
    }
}