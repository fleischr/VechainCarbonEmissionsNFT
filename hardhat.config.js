import "@nomicfoundation/hardhat-toolbox";
import "@vechain/hardhat-vechain";
import '@vechain/hardhat-ethers';

const config = {
  solidity: "0.8.19",
  networks: {
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
};

export default config;