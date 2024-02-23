// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC165, ERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils//Strings.sol";
import {IERC721Metadata} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract NFT is IERC165, ERC165, IERC721, IERC721Metadata, IERC721Receiver {
    error Invalid_Receiver(address);

    using Strings for uint256;
    string _name;
    string _symbol;

    mapping(uint256 tokenId => address) owners;
    mapping(address owner => uint256) _balances;
    mapping(uint256 tokenId => address) _tokenApprovals;
    mapping(address owner => mapping(address operator => bool)) _spenderApprovals;

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

    /**
     * Returns balance of owner
     * @param owner address of owner
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Invalid address");
        return _balances[owner];
    }

    /**
     * To return owner of the specified token
     * @param _tokenId id of token
     */
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = owners[_tokenId];
        require(owner != address(0), "Inavlid address");
        return owner;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() public pure returns (string memory) {
        return "";
    }

    /**
     * returns the uniform resource identifier of the token
     * @param tokenId id of token
     */
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

    /**
     * to add and remove spenders for all assets of owner
     * @param spender address of spender
     * @param approved state of approval
     */
    function setApprovalForAll(address spender, bool approved) public {
        require(spender != address(0), "Invalid address");
        _spenderApprovals[msg.sender][spender] = approved;
        emit ApprovalForAll(msg.sender, spender, approved);
    }

    /**
     * gives permission to spender to transfer token to another account
     * @param tokenId id of the nft
     * @param spender address of spender
     */
    function approve(address spender, uint256 tokenId) public {
        address owner = owners[tokenId];
        require(owner == msg.sender, "You cant approve");
        require(spender != address(0), "Invalid address");
        _tokenApprovals[tokenId] = spender;
        emit Approval(owner, spender, tokenId);
    }

    /**
     * Get address of the approved spender
     * @param tokenId id of the token
     */
    function getApproved(uint256 tokenId) public view returns (address) {
        require(ownerOf(tokenId) != address(0), "Invalid address");
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
        return _spenderApprovals[owner][spender];
    }

    /**
     * To transfer token from `from` to `to`
     * @param from address of token holder(from)
     * @param to address of token receiver(to)
     * @param tokenId id of the token
     */
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(from == owners[tokenId], "not owner of token");
        require(to != address(0), "Invalid address");
        require(isApprovedForAll(from, msg.sender));
        _balances[from]--;
        _balances[to]++;
        owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    /**
     * Safely transfers token to token receiver from token holder
     * @param from address of token holder
     * @param to address of token receiver
     * @param tokenId id of token
     * @param data data to be called with transfer
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        transferFrom(from, to, tokenId);
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    data
                )
            returns (bytes4 returnvalue) {
                if (returnvalue != IERC721Receiver.onERC721Received.selector) {
                    revert Invalid_Receiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert Invalid_Receiver(to);
                }
            }
        }
    }

    /**
     * Safely transfer token from token holder to token receiver
     * this function looks the same as the previous one but it doesn't have the data param
     * @param from address of token holder
     * @param to address of token receiver
     * @param tokenId id of token
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        transferFrom(from, to, tokenId);
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    ""
                )
            returns (bytes4 returnvalue) {
                if (returnvalue != IERC721Receiver.onERC721Received.selector) {
                    revert Invalid_Receiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert Invalid_Receiver(to);
                }
            }
        }
    }

    /**
     * To mint tokens to an address
     * @param to address to mint tokens to
     * @param tokenId id of the token
     */
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "Invalid address");
        require(owners[tokenId] == address(0), "already minted");
        _balances[to]++;
        owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }

    /**
     * Burns token of the owner
     * @param tokenId id of token to burn
     */
    function burn(uint256 tokenId) internal {
        address owner = owners[tokenId];
        require(owners[tokenId] != address(0), "Invalid address");
        _balances[owner]--;
        delete owners[tokenId];
        delete _tokenApprovals[tokenId];
        emit Transfer(owner, address(0), tokenId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {}
}
