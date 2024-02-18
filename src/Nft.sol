//SPDX-License-identifier: MIT
pragma solidity 0.8.20;

import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC165, ERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils//Strings.sol";
import {IERC721Metadata} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol";

abstract contract NFT is IERC165, IERC721, IERC721Metadata, IERC721Receiver {
    using Strings for uint256;
    string _name;
    string _symbol;

    mapping(uint256 tokenId => address) owners;
    mapping(address owner => uint256) _balances;
    mapping(uint256 tokenId => address) _tokenApprovals;
    mapping(address owner => mapping(address operator => bool)) _operatorApprovals;

    /**
     * Initializing contract by setting name and symbol
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * Returns the name of the token
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * Returns the symbol of the token
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Invalid address");
        return _balances[owner];
    }

    function OwnerOf(uint256 _tokenId) public view returns (address) {
        address owner = owners[_tokenId];
        require(owner != address(0), "Inavlid address");
        return owner;
    }

    function _baseURI() public pure returns (string memory) {
        return "";
    }

    function tokenURI(
        uint256 tokenId /**view */
    ) public pure returns (string memory) {
        // implement a check to validate token owner
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string.concat(baseURI, tokenId.toString())
                : "";
    }

    function setApproveForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
    }

    function approve(uint256 tokenId, address spender) public {
        address owner = owners[tokenId];
        require(owner == msg.sender, "You cant approve");
        require(spender != address(0), "Invalid address");
        setApproveForAll(spender, true);
        _tokenApprovals[tokenId] = spender;
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(OwnerOf(tokenId) != address(0), "Invalid address");
        return _tokenApprovals[tokenId];
    }

    /**
     * To check whether spender is approved
     * @param owner owner address
     * @param spender spender address
     */
    function isApprovedForAll(
        address owner,
        address spender
    ) public view returns (bool) {
        return _operatorApprovals[owner][spender];
    }
}
