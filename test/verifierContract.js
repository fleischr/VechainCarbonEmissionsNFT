const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");

  describe("verifierContract", function () {

    describe("getMessageHash", function() {
        it("should return the correct message hash", async function() {
            const message = "Hello, world!";
            const expectedHash = web3.utils.soliditySha3(message);

            const actualHash = await verifySignature.getMessageHash(message);

            expect(actualHash).to.equal(expectedHash);
        });
    });

    describe("getEthSignedMessageHash", function() {
        it("should return the correct Ethereum signed message hash", async function() {
            const messageHash = web3.utils.soliditySha3("Hello, world!");
            const expectedEthSignedMessageHash = web3.utils.soliditySha3(
                `\x19Ethereum Signed Message:\n32${messageHash.toString("hex")}`
            );

            const actualEthSignedMessageHash = await verifySignature.getEthSignedMessageHash(messageHash);

            expect(actualEthSignedMessageHash).to.equal(expectedEthSignedMessageHash);
        });
    });

    describe("verify", function() {
        it("should verify the signature correctly", async function() {
            const signer = accounts[0];
            const message = "Hello, world!";
            const messageHash = await verifySignature.getMessageHash(message);
            const ethSignedMessageHash = await verifySignature.getEthSignedMessageHash(messageHash);

            // Signing the message hash
            const signature = await web3.eth.sign(ethSignedMessageHash, signer);
            const { v, r, s } = web3.eth.accounts._decodeSignature(signature);

            const isValid = await verifySignature.verify(signer, message, signature);

            expect(isValid).to.be.true;
        });
    });

  });