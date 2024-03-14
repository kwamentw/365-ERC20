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

/**
 * SOLUTION:
 * Alice deploys SecuredFindThisHash with 10 Ether.
2. Bob finds the correct string that will hash to the target hash. ("Ethereum").
3. Bob then finds the keccak256(Address in lowercase + Solution + Secret). 
   Address is his wallet address in lowercase, solution is "Ethereum", Secret is like an password ("mysecret") 
   that only Bob knows whic Bob uses to commit and reveal the solution.
   keccak2566("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266Ethereummysecret") = '0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36'
3. Bob then calls commitSolution("0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36"), 
   where he commits the calculated solution hash with gas price set to 15 gwei.
4. Eve is watching the transaction pool for the answer to be submitted.
5. Eve sees Bob's answer and he also calls commitSolution("0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36")
   with a higher gas price than Bob (100 gwei).
6. Eve's transaction was mined before Bob's transaction, but Eve has not got the reward yet.
   He needs to call revealSolution() with exact secret and solution, so lets say he is watching the transaction pool
   to front run Bob as he did previously
7. Then Bob calls the revealSolution("Ethereum", "mysecret") with gas price set to 15 gwei;
8. Let's consider that Eve's who's watching the transaction pool, find's Bob's reveal solution transaction and he also calls 
   revealSolution("Ethereum", "mysecret") with higher gas price than Bob (100 gwei)
9. Let's consider that this time also Eve's reveal transaction was mined before Bob's transaction, but Eve will be
   reverted with "Hash doesn't match" error. Since the revealSolution() function checks the hash using 
   keccak256(msg.sender + solution + secret). So this time eve fails to win the reward.
10.But Bob's revealSolution("Ethereum", "mysecret") passes the hash check and gets the reward of 10 ether.


LInk to the write-up: https://solidity-by-example.org/hacks/front-running/
 */
