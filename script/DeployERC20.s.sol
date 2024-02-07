// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {FourbToken} from "../src/erc20.sol";

contract FourbTokenTest is Script {
    FourbToken mytoken;

    function run() external returns (FourbToken) {
        vm.startBroadcast();
        mytoken = new FourbToken("FOURB", "4B", 18, 20000);
        vm.stopBroadcast();

        return mytoken;
    }
}
