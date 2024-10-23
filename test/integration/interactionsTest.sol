// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundIt} from "../../src/FundIt.sol";
import {DeployFundIt} from "../../script/DeployFundIt.s.sol";
import {FundFundIt, WithdrawFundIt} from "../../script/Interactions.s.sol";

contract FundItTestIntegration is Test {
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

    function testUserCanFundInteractions() public {
        FundFundIt fundFundIt = new FundFundIt();
        fundFundIt.fundFundIt(address(fundIt));

        WithdrawFundIt withdrawFundIt = new WithdrawFundIt();
        withdrawFundIt.withdrawFundIt(address(fundIt));

        assert(address(fundIt).balance == 0);
    }
}
