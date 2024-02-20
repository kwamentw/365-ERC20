// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {NFT} from "./Nft.sol";

abstract contract CustomToken is NFT {
    constructor() NFT("FASTCARTOKEN", "FSCRTKN") {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }

    function _burn(uint256 tokenId) external {
        burn(tokenId);
    }
}
