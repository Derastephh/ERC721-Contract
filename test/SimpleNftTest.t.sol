// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {SimpleNft} from "../src/SimpleNft.sol";
import {DeployNft} from "script/DeploySimpleNft.s.sol";

contract SimpleNftTest is Test {
    DeployNft deployNft;
    SimpleNft simpleNft;
    address public DERA = makeAddr("dera");
    string public constant PUB =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    string public constant BERNARD =
        "https://ipfs.io/ipns/k51qzi5uqu5djrlqepzand3pd8xoivtt7beniz182hv7tby8d1mbe8uddv146g";

    function setUp() public {
        deployNft = new DeployNft();
        simpleNft = deployNft.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedname = "Dogie";
        string memory actualName = simpleNft.name();
        assert(
            keccak256(abi.encodePacked(expectedname)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testMintAndHaveBalance() public {
        vm.prank(DERA);
        simpleNft.mintNft(BERNARD);
        assert(simpleNft.balanceOf(DERA) == 1);
        assert(simpleNft.ownerOf(0) == DERA);
        assert(
            keccak256(abi.encodePacked(BERNARD)) ==
                keccak256(abi.encodePacked(simpleNft.tokenURI(0)))
        );
    }
}
