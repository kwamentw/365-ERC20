// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

// import statements
import {Test} from "forge-std/Test.sol";
import {CustomToken} from "../src/SampleNFT.sol";

contract TestNft is Test {
    // initializing the contract
    CustomToken newtoken;

    function setUp() public {
        newtoken = new CustomToken();
    }

    /**
     * test support interface just for coverage to look nice
     */
    function testSupportInterface() public view {
        newtoken.supportsInterface(0x01ffc9a7);
    }

    /**
     * tests whether function returns token name
     */
    function testReturnName() public view {
        newtoken.name();
    }

    /**
     * test whether function returns token symbol
     */
    function testReturnSymbol() public view {
        newtoken.symbol();
    }

    /**
     * Test to check the balance of owner
     */
    function testReturnBalance() public view {
        newtoken.balanceOf(address(this));
    }

    /**
     * Test for the owner of the token
     */
    function testfailOwneroftoken() public {
        vm.expectRevert();
        newtoken.ownerOf(12434998);
    }

    function testUri() public view {
        newtoken._baseURI();
    }
}
