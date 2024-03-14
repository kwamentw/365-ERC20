// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title A Frontrunnable contract
 * @author Solidity by example
 * @notice it will be commented how this will be frontrunnable
 */

/**
 *This is how the program will be front ran;
 * Before that you'd have to know that
 * transactions take some time before they are mined
 * Transactions not yet mined are put in the transaction pool
 * Transactions with higher gas prices are mined first cos miners too have to make profit
 *
 * Alice deploys Frontrun with 10 ether
 * Bod finds the target string that will hash to the target has ("Ethereum")
 * Bob calls solve(Ethereum) with gas price set to 15 wei
 * Eve is watching the transaction pool for the answer to be submitted
 * Eve sees Bobs answer and calls solve(Etheruem) with a higher gas price than boa of 150 wei
 * Eve's transaction was mined before Bobs transaction & Eve won the 10 ether
 */
contract Frontrun {
    bytes32 public constant HASH =
        0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    constructor() payable {}

    function solve(string memory solution) public {
        require(
            hash == keccak256(abi.encodePacked(solution)),
            "Incorrect answer"
        );

        (bool sent, ) = (msg.sender).call{value: 10 ether}("");
        require(sent, "failed to send ether");
    }
}
