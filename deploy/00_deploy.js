const { ethers, getNamedAccounts } = require("hardhat");

async function main() {
  //const emissionsNFTFactory = await hre.ethers.deployContract("emissionsNFTFactory", [], {});
  //await emissionsNFTFactory.waitForDeployment();

  console.log("deploying emissionsNFT contract...");

  const { deployer } = await getNamedAccounts();
  const deployerSigner = await ethers.getSigner(deployer);

  const MyContract = await ethers.getContractFactory("emissionsNFT", deployerSigner);
  const myContract = await MyContract.deploy();

  await myContract.deployed();

  console.log("emissionsNFT deployed to:", myContract.address);

/*  const emissionsNFT = await hre.deployments.deploy('emissionsNFT', { from: deployer});

  console.log(
    `EmissionsNFT Contract deployed to ${emissionsNFT.target}`
  );*/
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
