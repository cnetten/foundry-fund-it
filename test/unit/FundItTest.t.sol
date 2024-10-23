// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundIt} from "../../src/FundIt.sol";
import {DeployFundIt} from "../../script/DeployFundIt.s.sol";

contract FundItTest is Test {
    FundIt fundIt;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundIt deployFundIt = new DeployFundIt();
        fundIt = deployFundIt.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundIt.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundIt.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundIt.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundIt.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // the next TX will be sent by USER
        fundIt.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundIt.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundIt.fund{value: SEND_VALUE}();

        address funder = fundIt.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundIt.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundIt.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        uint256 startingOwnerBalance = fundIt.getOwner().balance;
        uint256 startingFundItBalance = address(fundIt).balance;

        vm.prank(fundIt.getOwner());
        fundIt.withdraw();

        uint256 endingOwnerBalance = fundIt.getOwner().balance;
        uint256 endingFundItBalance = address(fundIt).balance;
        assertEq(endingFundItBalance, 0);
        assertEq(startingFundItBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint256 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundIt.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundIt.getOwner().balance;
        uint256 startingFundItBalance = address(fundIt).balance;

        vm.startPrank(fundIt.getOwner());
        fundIt.withdraw();
        vm.stopPrank();

        assert(address(fundIt).balance == 0);
        assert(startingFundItBalance + startingOwnerBalance == fundIt.getOwner().balance);
    }
}
