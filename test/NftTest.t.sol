// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {CustomToken} from "../src/SampleNFT.sol";

contract TestNft is Test {
    CustomToken newtoken;

    function setUp() public {
        newtoken = new CustomToken();
    }

    function testSupportInetrface() public view {
        newtoken.supportsInterface(0x01ffc9a7);
    }

    function testReturnName() public view {
        newtoken.name();
    }

    function testReturnSymbol() public view {
        newtoken.symbol();
    }

    function testReturnBalance() public view {
        newtoken.balanceOf(address(this));
    }

    function testfailOwneroftoken() public {
        vm.expectRevert();
        newtoken.ownerOf(12434998);
    }
}
