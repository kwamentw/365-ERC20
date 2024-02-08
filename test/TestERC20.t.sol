// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {FourbToken} from "../src/erc20.sol";

contract TestFourbToken {
    FourbToken mytoken;

    function setUp() public {
        mytoken = new FourbToken("FourB", "4B", 18, 23444000);
    }
}
