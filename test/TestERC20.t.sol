// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {FourbToken} from "../src/erc20.sol";
import {console2} from "forge-std/console2.sol";

contract TestFourbToken is Test {
    FourbToken mytoken;

    function setUp() public {
        mytoken = new FourbToken("FourB", "4B", 18, 200000);
    }

    function testTransfer() public {
        uint256 bal = mytoken.balanceOf(address(54));
        mytoken.TransferToken(address(54), 2300);
        assertEq(bal + 2300, mytoken.balanceOf(address(54)));
        console2.log(mytoken.balanceOf(address(54)));
        console2.log(mytoken.balanceOf(address(this)));
    }
}
