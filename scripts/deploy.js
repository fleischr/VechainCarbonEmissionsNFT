// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat/types");
const deployFunction = require("hardhat-deploy/types");

const main = async function(hre) {
  const { deployer } = await hre.getNamedAccounts();
  //const emissionsNFTFactory = await hre.ethers.deployContract("emissionsNFTFactory", [], {});
  //await emissionsNFTFactory.waitForDeployment();

  const emissionsNFT = await hre.deployments.deploy('emissionsNFT', { from: deployer});

  console.log(
    `EmissionsNFT Contract deployed to ${emissionsNFT.target}`
  );
}

main.id = "emissionsNFT";
main.tags = ['regular'];

//export default main;

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
