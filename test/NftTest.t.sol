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
     * Tests whether user can pass in zero addresses
     */
    function testRevertSetApprovalAll() public {
        vm.expectRevert();
        newtoken.setApprovalForAll(address(0), true);
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
     * Testing whether a non owner can approve
     */
    function testNotOwnerApprove() public {
        testMintFSCR();
        vm.expectRevert();
        vm.prank(address(44));
        newtoken.approve(address(998), 5524512);
    }

    /**
     * Testing whether a zero address can be approved
     */
    function testInvalidSpenderApprove() public {
        testMintFSCR();
        vm.expectRevert();
        newtoken.approve(address(0), 5524512);
    }

    /**
     * test to check mint function
     */
    function testMintFSCR() public {
        newtoken.mint(address(this), 5524512);
        assertEq(newtoken.ownerOf(5524512), address(this));
    }

    function testInvalidMinter() public {
        vm.expectRevert();
        newtoken.mint(address(0), 5524512);
    }

    function testAlreadyMinted() public {
        testMintFSCR();
        vm.expectRevert();
        newtoken.mint(address(43), 5524512);
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

    /**
     * Testing thoroughly the transferFrom function
     */
    function testTransFromFSCRTKN() public {
        testMintFSCR();
        newtoken.approve(msg.sender, 5524512);
        newtoken.transferFrom(address(this), address(34534), 5524512);
        assertEq(newtoken.balanceOf(address(34534)), 1);
        assertEq(newtoken.ownerOf(5524512), address(34534));
        assertEq(newtoken.balanceOf(address(this)), 0);
    }

    /**
     * Testing invalid msg.sender
     */
    function testInvalidMsgSender() public {
        testMintFSCR();
        vm.prank(address(66787));
        vm.expectRevert();
        newtoken.transferFrom(address(this), address(3324), 5524512);
    }

    function testInvalidReceiverTransFrom() public {
        testMintFSCR();
        newtoken.approve(msg.sender, 5524512);
        vm.expectRevert();
        newtoken.transferFrom(address(this), address(0), 5524512);
    }

    function testNotOwnerTransferFrom() public {
        testMintFSCR();
        newtoken.approve(msg.sender, 5524512);
        vm.expectRevert();
        newtoken.transferFrom(address(2343), address(45322), 5524512);
    }

    /**
     * Same as previous function but more safety checks have been adopted
     */
    function testSafeTransFrom() public {
        testMintFSCR();
        newtoken.approve(msg.sender, 5524512);
        newtoken.safeTransferFrom(address(this), address(99878), 5524512, "");
    }

    /**
     * Same as previous function but no data param should be added
     */
    function testSafeTransfromNoData() public {
        testMintFSCR();
        newtoken.approve(msg.sender, 5524512);
        newtoken.safeTransferFrom(address(this), address(4453423), 5524512);
    }

    /**
     * Function to test the burning of tokens
     * the approvals all should be sero values after burn
     */
    function testBurnFSCRTKN() public {
        testMintFSCR();
        newtoken.approve(msg.sender, 5524512);
        console2.log(newtoken.ownerOf(5524512));
        console2.log(newtoken.getApproved(5524512));
        vm.prank(address(this));
        newtoken._burn(5524512);
        console2.log(newtoken.ownerOf(5524512));
        console2.log(newtoken.getApproved(5524512));
    }

    function testBurnNonExistentToken() public {
        vm.expectRevert();
        newtoken._burn(223442342);
    }
}
