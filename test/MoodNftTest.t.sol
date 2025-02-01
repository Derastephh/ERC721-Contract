// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    DeployMoodNft deployMoodNft;

    string private constant HAPPY_SVG_URI =
        string(
            abi.encodePacked(
                "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5z",
                "PSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIx",
                "MDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIg",
                "Lz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI3MCIgY3k9IjgyIiBy",
                "PSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8",
                "L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTIt",
                "LjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAv",
                "Pgo8L3N2Zz4="
            )
        );
    string private constant SAD_SVG_URI =
        string(
            abi.encodePacked(
                "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5z",
                "PSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIx",
                "MDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIg",
                "Lz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI3MCIgY3k9IjgyIiBy",
                "PSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8",
                "L2c+CiAgICA8cGF0aCBkPSJtNzIuNjkgMTMwYy0uNjMgMjYuMjEgNjQuMjggNDAuOTggODEuNDgt",
                "LjYzIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAv",
                "Pgo8L3N2Zz4="
            )
        );

    address public DERA = makeAddr("dera");
    address public STEPH = makeAddr("steph");

    function setUp() public {
        deployMoodNft = new DeployMoodNft();
        moodNft = deployMoodNft.run();
    }

    function testViewTokenURI() public {
        vm.prank(DERA);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipMoodByNotOwner() public {
        vm.prank(DERA);
        moodNft.mintNft();

        vm.expectRevert();
        vm.prank(STEPH);
        moodNft.flipMood(0);
    }

    function testFlipNftToSad() public {
        vm.prank(DERA);
        moodNft.mintNft();

        vm.prank(DERA);
        moodNft.flipMood(0);

        assert(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(SAD_SVG_URI))
        );
    }
}
