const fs = require('fs');
require('dotenv');
const { Transaction, secp256k1 } = require('thor-devkit')
const bent = require('bent')

const deployedContract = "0x0F7666508Ca42b92aB81B525A818F11492d057f1";
const deployedNetwork = "vechain_testnet";

const GHGOrgId = "ABC123";
const GHGOrgDescription = "Test Organization";

var emissionsDataSample = {
    GHGOrgId : "ABC123",
};

async function main() {

    console.log("Getting emissions NFT ABI");
    const emissionsNFT_abi = JSON.parse(fs.readFileSync('../deployments/vechain_testnet/emissionsNFT.json', 'utf-8'));
    console.log(emissionsNFT_abi);

    const PRIVATE_KEY = process.env.PRIVATE_KEY;

    const nftcontract = new ethers.Interface(emissionsNFT_abi.abi);
    const clauses = [{
      to: address,
      value: '0x0',
      data: nftcontract.encodeFunctionData("defineGHGOrg", [GHGOrgId,GHGOrgDescription])
    }];

      // simulate the transaction
    const tests = await post('/accounts/*', {
      clauses: transaction.body.clauses,
      caller: wallet.address,
      gas: transaction.body.gas
    })

    // check for errors and throw if any
    for (const test of tests) {
      if (test.reverted) {

        const revertReason = test.data.length > 10 ? ethers.AbiCoder.defaultAbiCoder().decode(['string'], `0x${test.data.slice(10)}`) : test.vmError;
        throw new Error(revertReason);
      }
    }

    // get fee delegation signature
    const { signature } = await getSponsorship('/by/90', { origin: wallet.address, raw: `0x${transaction.encode().toString('hex')}` });
    const sponsorSignature = Buffer.from(signature.substr(2), 'hex');

    // sign the transaction
    const signingHash = transaction.signingHash();
    const originSignature = secp256k1.sign(signingHash, Buffer.from(wallet.privateKey.slice(2), 'hex'));
    transaction.signature = Buffer.concat([originSignature, sponsorSignature]);

    // submit the transaction
    const rawTransaction = `0x${transaction.encode().toString('hex')}`;
    const { id } = await post('/transactions', { raw: rawTransaction });
    console.log('Submitted with txId', id);

    console.log("Interacting with contract");

    console.log("Creating a GHG org");

    console.log("Creating and approving an ESG data steward");
    
    console.log("Minting an emissions NFT...");
    
    console.log("Adding data...");

    console.log("Adding and approving an emissions verifier");

    console.log("Emissions verifier signing off on the data quality");
    
}

async function createAndSendTransaction(txnType,tokenID) {

  // fetch status information for the network
  const bestBlock = await get('/blocks/best');
  const genesisBlock = await get('/blocks/0');

  // build the transaction
  const transaction = new Transaction({
    chainTag: Number.parseInt(genesisBlock.id.slice(-2), 16),
    blockRef: bestBlock.id.slice(0, 18),
    expiration: 32,
    clauses,
    gas: bestBlock.gasLimit,
    gasPriceCoef: 0,
    dependsOn: null,
    nonce: Date.now(),
    reserved: {
      features: 1
    }
  });



}


main()
  .then(() => process.exit(0))
  .catch(console.error)