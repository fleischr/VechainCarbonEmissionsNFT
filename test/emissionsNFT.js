const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");

  describe("emissionsNFT", function () {

    async function deployEmissionsNFT(){
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();

        const EmissionsNFTContract = await ethers.getContractFactory("emissionsNFT");
        const contract_deployment = await EmissionsNFTContract.deploy();

        return { lock, owner, otherAccount };

    };

    describe("Deployment", function () {
        
        it("Should make the contract deployer an acknowledged data steward", async function (){

        });

        it("Should permit the contract deploy to auto approve data stewards", async function(){
            
        });

        it("Should set mint readiness to false w/o any GHG org defined", async function() {

        });

        it("Should return an inital token id of 1", async function(){

        });
    });

    describe("DataStewards", function (){

    });

    describe("GHGOrgs", function(){
        it("should require the data steward role for creating reporting ghg orgs", async function(){

        });

        it("should set mint readiness to true upon initial GHG org definition", async function() {

        });

    });

    describe("EmissionsVerifiers", function(){
        it("should allow a data steward to approve the emissions verifier", async function(){
            
        });

    });

    describe("EmissionsData",function(){

        it("should only allow this activity for data stewards", async function(){

        });

        it("should mint with appropriate from to dates", async function(){

        });

        it("should require a GHG org to be defined", async function(){

        });

        it("should add extra data to existing token", async function(){

        });

        it("should automatically add an adjustment record based on token id", async function(){

        });

    });

    describe("EmissionsDataVerification",function(){
        it("should only permit acknowledged verifiers", async function(){

        });
        it("should reject invalid signatures", async function(){
            
        });

    });
    
  });