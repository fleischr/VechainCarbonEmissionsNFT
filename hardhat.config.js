require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");
require("@vechain/hardhat-vechain");
require('@vechain/hardhat-ethers');
require('dotenv/config');
require('hardhat-deploy');

const ethUtil = require('ethereumjs-util');

const PRIVATE_KEY = process.env.PRIVATE_KEY;

//check deployer public address
if (!process.env.PRIVATE_KEY) {
  throw new Error(
    "Please set your PRIVATE_KEY in a .env file or in your environment variables"
  );
} else {
  // Replace the following private key with your actual private key.
  const hexKey = process.env.PRIVATE_KEY.replace("0x","")
  const privateKey = Buffer.from(hexKey, 'hex');

  // Derive the public key
  const publicKey = ethUtil.privateToPublic(privateKey);
  // Derive the Ethereum address from the public key
  const my_address = ethUtil.publicToAddress(publicKey, true); // The 'true' parameter here ensures the address is returned as a Buffer.

  // Convert the address to a hexadecimal string
  const my_addressHex = ethUtil.bufferToHex(my_address);

  // Convert public key to hex string
  const publicKeyString = publicKey.toString('hex');
  const ethereumAddressString = ethUtil.bufferToHex(my_addressHex);
  console.log("Deployer Public Key:", publicKeyString);
  console.log("Deployer address: ", ethereumAddressString );
}

const accounts = [
  process.env.PRIVATE_KEY ?? PRIVATE_KEY, // deployer
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
      accounts,
      restful: true,
      gas: 10000000 ,
      loggingEnabled : true
    },
    vechain_testnet: {
      url: "https://node-testnet.vechain.energy",
      accounts,
      restful: true,
      gas: 10000000,
      
      // optionally use fee delegation to let someone else pay the gas fees
      // visit vechain.energy for a public fee delegation service
      delegate: {
        url: "https://sponsor-testnet.vechain.energy/by/90"
      },
      loggingEnabled: true
    },
    vechain_mainnet: {
      url: "https://node-mainnet.vechain.energy",
      accounts,
      restful: true,
      gas: 10000000,
    },
  },
  namedAccounts
};

module.exports = config;