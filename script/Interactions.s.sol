// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {SimpleNft} from "../src/SimpleNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MoodNft} from "src/MoodNft.sol";

contract MintNft is Script {
    string public constant BERNARD =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "SimpleNft",
            block.chainid
        );
        mintNftOnContract(mostRecentDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        SimpleNft(contractAddress).mintNft(BERNARD);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    function run() external {
        address mostRecentDeployedMoodNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        mintMoodNftOnContract(mostRecentDeployedMoodNft);
    }

    function mintMoodNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script {
    uint256 public constant FLIP_MOOD = 0;

    function run() external {
        address mostRecentDeployedFlipMoodNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        mintFlipMoodNftOnContract(mostRecentDeployedFlipMoodNft);
    }

    function mintFlipMoodNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).flipMood(FLIP_MOOD);
        vm.stopBroadcast();
    }
}
