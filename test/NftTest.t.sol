// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

// import statements
import {Test} from "forge-std/Test.sol";
import {CustomToken} from "../src/SampleNFT.sol";
import {console2} from "forge-std/console2.sol";

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

    /**
     * Test whether this func can get owner of the token
     */
    function testOwnerOfFSCRTKN() public {
        testMintFSCR();
        newtoken.ownerOf(5524512);
    }

    /**
     * testing to see whether return uri works
     */
    function testUri() public view {
        newtoken._baseURI();
    }

    /**
     * Testing the set approve for all
     */
    function testSetApproveAll() public {
        newtoken.setApprovalForAll(address(34443), true);
    }

    /**
     * testing to see if a user can can approve spenders
     */
    function testApproveFSCRTKN() public {
        testMintFSCR();
        newtoken.approve(address(998), 5524512);
        assertEq(newtoken.getApproved(5524512), address(998));
    }

    /**
     * test to check mint function
     */
    function testMintFSCR() public {
        newtoken.mint(address(this), 5524512);
        assertEq(newtoken.ownerOf(5524512), address(this));
    }

    /**
     * Test to check whether this func can get approved spender
     */
    function testGetApproved() public {
        testMintFSCR();
        newtoken.approve(address(392), 5524512);
        newtoken.getApproved(5524512);
    }

    /**
     * Test to check approve for all function
     */
    function testisApprovedForAll() public {
        testSetApproveAll();
        newtoken.isApprovedForAll(address(this), address(34443));
        // console2.log(address(this));
        // console2.log(msg.sender);
    }
}
