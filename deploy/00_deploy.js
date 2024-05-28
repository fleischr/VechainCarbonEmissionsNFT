const { ethers } = require("hardhat");

async function deployFunc({ getNamedAccounts, deployments }) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("deploying my emissionsNFT contract...");

  const anchorContract = "0x1234567890abcdef1234567890abcdef12345678";

  // Deploy the contract using Hardhat Deploy's deploy function
  const deploymentResult = await deploy("emissionsNFT", {
    from: deployer,
    args: [anchorContract],
    log: true,
  });

  console.log("emissionsNFT deployed to:", deploymentResult.address);
}

module.exports = deployFunc;

deployFunc.tags = ['regular'];
