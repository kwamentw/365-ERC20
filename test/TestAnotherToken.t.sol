//SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {AnotherToken} from "../src/AnotherToken.sol";

/**
 * @title A test script for the erc20 base contract
 * @author Kwame 4B
 * @notice Just a hands on experience
 */

contract AnotherTokenTest is Test {
    // contract to test
    AnotherToken token;
    //address of the owner
    address newGuy = makeAddr("newGuy");

    //setting up contract for test
    function setUp() public {
        token = new AnotherToken("HandsOnToken", "HOT");
        token.mint(newGuy, 123001e18);
    }

    /**
     * Check whether the token has a name
     */
    function testName() public {
        string memory name = token.name();
        assertEq(name, "HandsOnToken");
    }

    /**
     * Test whether symbols for the token have been added
     */
    function testSymbol() public {
        string memory symbol = token.symbol();
        assertEq(symbol, "HOT");
    }

    /**
     * test whether number of decimals is 18
     */
    function testDecimals() public {
        assertEq(token.decimals(), 18);
    }

    /**
     * test whether some tokens have been minted
     */
    function testTotalSupp() public {
        uint256 totalSupply = token.totalSupply();
        assertEq(totalSupply, 123001e18);
    }

    /**
     * test the balance of account owner
     */
    function testBala() public {
        assertGt(token.balanceOf(newGuy), 1);
    }

    /**
     * test whether user has some allowance
     */
    function testAllowance() public {
        vm.prank(newGuy);
        token.approve(address(12), 120e18);
        assertGt(token.allowance(newGuy, address(12)), 1);
    }
}
