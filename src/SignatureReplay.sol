//SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {ECDSA} from "./ECDSA.sol";

/**
 * @title Demonstrating signature replay
 * @author Solidity by example
 * @notice Just to understand this concept more is the reason i typed this out again
 */
contract MultiSigWallet {
    using ECDSA for bytes32;

    address[2] public owners;

    constructor(address[2] memory _owners) payable {
        owners = _owners;
    }

    function deposit() external payable {}

    function transfer(
        address _to,
        uint256 _amount,
        bytes[2] memory _sigs
    ) external {
        bytes32 txHash = getTxHash(_to, _amount);
        require(_checkSigs(_sigs, txHash), "Invalid Sig");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function getTxHash(
        address _to,
        uint256 _amount
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount));
    }

    function _checkSigs(
        bytes[2] memory _sigs,
        bytes32 _txHash
    ) private view returns (bool) {
        bytes32 ethSignedHash = _txHash.toEthSignedMessageHash();

        for (i = 0; i < _sigs.length; i++) {
            address signer = ethSignedHash.recover(_sigs[i]);
            bool valid = signer == owners[i];

            if (!valid) {
                return false;
            }
        }
        return true;
    }
}

/**
 * SOLUTION
 * Sign messages with nonce and address of the contract.
 * Tools used in the solution REMIX
 * link to write-up;
 * https://solidity-by-example.org/hacks/signature-replay/
 */
