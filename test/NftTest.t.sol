// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {CustomToken} from "../src/SampleNFT.sol";

contract TestNft is Test {
    CustomToken newtoken;

    function setUp() public {
        newtoken = new CustomToken();
    }
}
