//SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {AnotherToken} from "../src/AnotherToken.sol";
import {console2} from "forge-std/console2.sol";

/**
 * @title A test script for the erc20 base contract
 * @author Kwame 4B
 * @notice Just a hands on experience
 */

contract AnotherTokenTest is Test {
    // contract to test
    AnotherToken token;
    //address of the owner
    address newGuy = makeAddr("newGuy");
    address RECEIVER = makeAddr("receiver");
    address weirdo = makeAddr("weirdo");

    //setting up contract for test
    function setUp() public {
        token = new AnotherToken("HandsOnToken", "HOT");
        token.mint(newGuy, 123001e18);
    }

    /**
     * Check whether the token has a name
     */
    function testName() public {
        string memory name = token.name();
        assertEq(name, "HandsOnToken");
    }

    /**
     * Test whether symbols for the token have been added
     */
    function testSymbol() public {
        string memory symbol = token.symbol();
        assertEq(symbol, "HOT");
    }

    /**
     * test whether number of decimals is 18
     */
    function testDecimals() public {
        assertEq(token.decimals(), 18);
    }

    /**
     * test whether some tokens have been minted
     */
    function testTotalSupp() public {
        uint256 totalSupply = token.totalSupply();
        assertEq(totalSupply, 123001e18);
    }

    /**
     * test the balance of account owner
     */
    function testBala() public {
        assertGt(token.balanceOf(newGuy), 1);
    }

    /**
     * test whether user has some allowance
     */
    function testAllowance() public {
        vm.prank(newGuy);
        token.approve(address(12), 120e18);
        assertGt(token.allowance(newGuy, address(12)), 1);
    }

    /**
     * test whether transferring to a specific address works
     * this is as per ERC20 standards
     */
    function testTransferHOT() public {
        vm.startPrank(newGuy);
        uint256 balOfReceiver = token.balanceOf(RECEIVER);
        assertTrue(token.transfer(RECEIVER, 120e18));
        uint256 UpdatedbalOfReceiver = token.balanceOf(RECEIVER);
        assertEq(balOfReceiver + 120e18, UpdatedbalOfReceiver);
        vm.stopPrank();
    }

    /**
     * test whether the test fails when 0 is passed as amount
     */
    function testfailTransferHOT() public {
        vm.prank(newGuy);
        token.transfer(RECEIVER, 0);
    }

    /**
     * test whether approving spenders wotk
     */
    function testApproveHOT() public {
        vm.startPrank(newGuy);
        uint256 prevAllowance = token.allowance(newGuy, RECEIVER);
        assertTrue(token.approve(RECEIVER, 120e18));
        uint256 afterAllowance = token.allowance(newGuy, RECEIVER);
        assertEq((prevAllowance + 120e18), afterAllowance);
        vm.stopPrank();
    }

    /**
     * To test whether owner can increase allowance when the needs arises
     * instead of a reapproval
     */
    function testIncreaseAllowance() public {
        testApproveHOT();
        uint256 oldallowance = token.allowance(newGuy, RECEIVER);
        vm.prank(newGuy);
        assertTrue(token.IncreaseAllowance(newGuy, RECEIVER, 12e18));
        uint256 newallowance = token.allowance(newGuy, RECEIVER);
        assertEq(oldallowance + 12e18, newallowance);
    }

    /**
     * Test whether owner can decrease the amount approved for spender
     */
    function testDecreaseAllowance() public {
        testApproveHOT();
        uint256 OldAllowance = token.allowance(newGuy, RECEIVER);
        vm.prank(newGuy);
        assertTrue(token.DecreaseAllowance(newGuy, RECEIVER, 13e18));
        uint256 NewAllowance = token.allowance(newGuy, RECEIVER);
        assertEq(OldAllowance - 13e18, NewAllowance);
    }

    /**
     * Checks whether a spender can send an allowed amount from the owner's account to specified address
     */
    function testTransferHOTFrom() public {
        testApproveHOT();

        vm.startPrank(RECEIVER);
        uint256 oldFromBal = token.balanceOf(newGuy);

        assertTrue(token.transferFrom(newGuy, weirdo, 110e18));

        uint256 newAllowance = token.allowance(newGuy, RECEIVER);
        uint256 newFromBal = token.balanceOf(newGuy);

        assertEq(newFromBal, oldFromBal - 110e18);
        assertEq(newAllowance, 120e18 - 110e18);
        assertEq(token.balanceOf(weirdo), 110e18);
        vm.stopPrank();
    }

    /**
     * test whether you can mint a certain amount to an address
     */
    function testMintHOT() public {
        uint256 totalsupplyHOT = token.totalSupply();
        token.mint(address(6031957), 12333);
        uint256 bal = token.balanceOf(address(6031957));
        assertEq(totalsupplyHOT + 12333, token.totalSupply());
        assertEq(bal, 12333);
    }

    /**
     * Checks whether the owner can burn some tokens
     */
    function testBurnHOT() public {
        uint256 totalsupplyHOT = token.totalSupply();
        token.burn(newGuy, 1234);
        assertEq(totalsupplyHOT - 1234, token.totalSupply());
    }
}
