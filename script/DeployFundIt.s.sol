// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundIt} from "../src/FundIt.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundIt is Script {
    function run() external returns (FundIt) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        // Mock
        FundIt fundIt = new FundIt(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundIt;
    }
}
