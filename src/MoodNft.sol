// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    enum Mood {
        HAPPY,
        SAD,
        SOLDIER
    }

    error MoodNft__CannotBeFlippedByNonOwner();

    uint256 private s_tokenCounter;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    constructor(
        string memory happyNftImageUri,
        string memory sadNftImageUri
    ) ERC721("MoodNft", "MN") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happyNftImageUri;
        s_sadSvgImageUri = sadNftImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function sendEth() public {
        address payable steph = payable(msg.sender);
        (bool success, ) = steph.call{value: 5 ether}("");
        if (!success) {
            revert();
        }
    }

    function flipMood(uint256 tokenId) public {
        if (_requireOwned(tokenId) != msg.sender) {
            revert MoodNft__CannotBeFlippedByNonOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getSadImageURI() public view returns (string memory) {
        return s_sadSvgImageUri;
    }
}
