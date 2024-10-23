//SPDX-license-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundIt} from "../src/FundIt.sol";
contract FundFundIt is Script {
   uint256 constant SEND_VALUE = 0.01 ether;
   function fundFundIt(address mostRecentlyDeployed) public {
              vm.startBroadcast();
        FundIt(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
   }
   function run() external {
    address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundIt", block.chainid);
    vm.startBroadcast();
    fundFundIt(mostRecentlyDeployed);
    vm.stopBroadcast();

   }
}

contract WithdrawFundIt is Script {
    function withdrawFundIt(address mostRecentlyDeployed) public {
    vm.startBroadcast();
        FundIt(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
   }
   function run() external {
    address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundIt", block.chainid);
    withdrawFundIt(mostRecentlyDeployed);

   }
}