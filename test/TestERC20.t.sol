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

    function testTransferToken() public {
        mytoken.mint(16000e18);
        uint256 bal = mytoken.balanceOf(address(54));
        mytoken.TransferToken(address(54), 2300e18);
        assertEq(bal + 2300e18, mytoken.balanceOf(address(54)));
        console2.log(mytoken.balanceOf(address(54)));
        console2.log(mytoken.balanceOf(address(this)));
    }

    function testApprove() public {
        mytoken.mint(16000e18);
        assertTrue(mytoken.ApproveSpender(1200 ether, address(35)));
        console2.log(mytoken.balanceOf(address(35)));
    }

    function testfailApprove() public {
        // The sender of the contract has to mint some tokens before he can approve someone to spend some
        vm.expectRevert(bytes("we cant do this"));
        mytoken.ApproveSpender(1234e18, address(2341));
    }

    function testTransferFrom() public {
        mytoken.mint(16000e18);
        assertTrue(mytoken.ApproveSpender(12000e18, address(992)));
        console2.log(mytoken.balanceOf(address(992)));
        assertTrue(
            mytoken.transferfrom(address(992), address(21444), 11000e18)
        );
    }
}
