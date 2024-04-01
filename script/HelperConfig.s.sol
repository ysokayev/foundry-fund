//SPDX-License-Identifier: MIT

//1.Deploy mocks when we are on a local anvil chain
//2.Keep track of contract address across different chains
//Sepolia ETH/USD: 0x694AA1769357215DE4FAC081bf1f309aDC325306
//

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";

contract HelperConfig is Script {
    //If anvil grab mock
    //otherwise use live network

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 9;
    int256 public constant INITIAL_PRICE = 8000e8;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else activeNetworkConfig = getOrCreateAnvilEthCOnfig();
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getOrCreateAnvilEthCOnfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        //price feed address
        //deploy mocks
        //return mock addresses

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
