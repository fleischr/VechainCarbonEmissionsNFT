require("@nomicfoundation/hardhat-toolbox");
require("@vechain/hardhat-vechain");
require('@vechain/hardhat-ethers');

const PRIVATE_KEY = process.env.PRIVATE_KEY;

if (!PRIVATE_KEY) {
  throw new Error(
    "Please set your PRIVATE_KEY in a .env file or in your environment variables"
  );
}

const accounts = [
  PRIVATE_KEY, // deployer
  process.env.DEPLOYER_PRIVATE_KEY ?? PRIVATE_KEY, // proxyOwner
  process.env.OWNER_PRIVATE_KEY ?? PRIVATE_KEY, // owner
];

// see https://github.com/wighawag/hardhat-deploy?tab=readme-ov-file#1-namedaccounts-ability-to-name-addresses
const namedAccounts = {
  deployer: { default: 0 },
  proxyOwner: { default: 1 },
  owner: { default: 2 },
};


const config = {
  solidity: { 
    version : "0.8.19", 
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  defaultNetwork: "vechain_testnet",
  networks: {
    localdev : {
      url : "http://localhost:8669",
      accounts: ["0x765573031fb5c056bff1b764a797a571478b6fcc97f34165b047da9b09c02e10"],
      restful: true,
      gas: 10000000  
    },
    vechain_testnet: {
      url: "https://node-testnet.vechain.energy",
      accounts: ["0x765573031fb5c056bff1b764a797a571478b6fcc97f34165b047da9b09c02e10"],
      restful: true,
      gas: 10000000,
      
      // optionally use fee delegation to let someone else pay the gas fees
      // visit vechain.energy for a public fee delegation service
      delegate: {
        url: "https://sponsor-testnet.vechain.energy/by/90"
      }
    },
    vechain_mainnet: {
      url: "https://node-mainnet.vechain.energy",
      accounts: ["0x765573031fb5c056bff1b764a797a571478b6fcc97f34165b047da9b09c02e10"],
      restful: true,
      gas: 10000000,
    },
  },
  namedAccounts
};

module.exports = config;