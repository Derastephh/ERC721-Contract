// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {SimpleNft} from "../src/SimpleNft.sol";

contract DeployNft is Script {
    function run() external returns (SimpleNft) {
        vm.startBroadcast();
        SimpleNft simpleNft = new SimpleNft();
        vm.stopBroadcast();
        return simpleNft;
    }
}
