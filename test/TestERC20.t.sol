// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {FourbToken} from "../src/erc20.sol";
import {console2} from "forge-std/console2.sol";

contract TestFourbToken is Test {
    FourbToken mytoken;

    function setUp() public {
        mytoken = new FourbToken("FourB", "4B", 18, 200000e18);
    }

    // Testing transfer function
    function testTransferToken() public {
        mytoken.mint(16000e18);
        uint256 bal = mytoken.balanceOf(address(54));
        mytoken.TransferToken(address(54), 2300e18);
        assertEq(bal + 2300e18, mytoken.balanceOf(address(54)));
        console2.log(mytoken.balanceOf(address(54)));
        console2.log(mytoken.balanceOf(address(this)));
    }

    // Testing whether approval works
    function testApprove() public {
        vm.startPrank(address(234));
        mytoken.mint(16000e18);
        assertTrue(mytoken.approve(12e18, address(35)));
        mytoken.balAllowances(address(35));
        vm.stopPrank();
    }

    // test checks when approve fails
    function testfailApprove() public {
        // The sender of the contract has to mint some tokens before he can approve someone to spend some
        vm.expectRevert(bytes("we cant do this"));
        mytoken.approve(1234e18, address(2341));
    }

    // test to check transferfrom function
    // i have a problem with testing this function
    // looks like this program wont work without the interface
    function testTransferFrom() public {
        address a = address(33);
        address b = address(12);
        vm.startPrank(address(a));
        mytoken.mint(16000e18);
        mytoken.approve(13000e18, b);
        vm.stopPrank();

        vm.prank(b);
        assertTrue(mytoken.transferfrom(a, address(21), 12000e18));
    }

    // Checking whether balances truly return
    function testBal() public {
        mytoken.mint(16e18);
        mytoken.balanceOf(address(this));
    }

    // testing whether mint works
    function testMint() public {
        assertTrue(mytoken.mint(12e18));
    }

    // testing whether you can burn tokens
    function testBurn() public {
        assertTrue(mytoken.mint(12e18));
        assertTrue(mytoken.burn(12e18));
    }
}
