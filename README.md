
# FundIt Project

## Overview

FundIt is a Solidity-based project designed to manage funding operations. This project includes smart contracts, deployment scripts, and tests to ensure the functionality and security of the funding process.

## Project Structure
```markdown
.env
.github/
	workflows/
		test.yml
.gitignore
.gitmodules
cache/
	solidity-files-cache.json
	test-failures
file:///home/foks/foundry/foundry-fund-it/foundry.toml
lib/
	chainlink-brownie-contracts/
		.github/
		.gitignore
		contracts/
		package.json
		file:///home/foks/foundry/foundry-fund-it/README.md
		version.txt
	forge-std/
		.gitattributes
		.github/
		.gitignore
		file:///home/foks/foundry/foundry-fund-it/foundry.toml
		LICENSE-APACHE
		LICENSE-MIT
		package.json
		file:///home/foks/foundry/foundry-fund-it/README.md
		...
file:///home/foks/foundry/foundry-fund-it/README.md
script/
	DeployFundIt.s.sol
	HelperConfig.s.sol
src/
	```

FundIt.sol


	PriceConverter.sol
test/
	FundItTest.t.sol
	mocks/
		...
```

## Documentation

For detailed documentation, please visit [Foundry Book](https://book.getfoundry.sh/).

## Usage

### Build

To build the project, run:

```shell
forge build
```

### Test

To run the tests, execute:

```shell
forge test
```

## Contracts

- [`FundIt.sol`](src/FundIt.sol): Main contract for managing funds.
- [`PriceConverter.sol`](src/PriceConverter.sol): Utility contract for price conversions.

## Scripts

- [`DeployFundIt.s.sol`](script/DeployFundIt.s.sol): Script to deploy the `FundIt` contract.
- [`HelperConfig.s.sol`](script/HelperConfig.s.sol): Helper script for configuration.

## Tests

- [`FundItTest.t.sol`](test/FundItTest.t.sol): Unit tests for the `FundIt` contract.
- [`mocks/`](test/mocks/): Mock contracts for testing purposes.

## Dependencies

This project uses the following libraries:

- [chainlink-brownie-contracts](lib/chainlink-brownie-contracts/)
- [forge-std](lib/forge-std/)

## Excerpt from `FundIt.sol`

```solidity
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundIt__NotOwner();

contract FundIt {
    using PriceConverter for uint256;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
```

## License

This project is licensed under the MIT License. See the [LICENSE](lib/forge-std/LICENSE-MIT) file for details.
