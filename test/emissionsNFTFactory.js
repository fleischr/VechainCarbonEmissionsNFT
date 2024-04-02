const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("emissionsNFTFactory", function () {
    async function deployEmissionsNFTFactory(){
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();
        const EmissionsNFTFactoryContract = await ethers.getContractFactory("emissionsNFTFactory");
        const contract_deployment = await EmissionsNFTFactoryContract.deploy();
        return { contract_deployment, owner, otherAccount };
    };

    describe("deployment", async function(){
        const{ factory, deployer, dataSteward } = await this.deployEmissionsNFTFactory();
        it("should allow creation of the contract", async function() {
            var emissionsNFT = await factory.createNFT();
            expect(emissionsNFT).to.not.equal(null);
        });

        it("should have at least a length of 1 deployed contract", async function() {
            var deployed = await factory.getDeployedNFTs();
            expect(deployed.length).to.equal(1);
        });
    });

  
  
});