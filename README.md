# Carbon Emissions NFT 
<i>A VeChain Developer Microgrant by <b>Ryan Fleischmann</b></i>

## Business Overview
Enterprises today are adopting carbon accounting as a standard business practice. The GHG Protocol defines a set of standards by which carbon emissions (and greenhouse gas emissions) are reported into sustainability reporting.

GHG Protocol reporting has additional complexity to typical corporate financial accounting because of:

1.) Scope 3 carbon emissions - which are carbon emissions that occur in the value chain, but are outside of a company's typical organizational boundary. Example: CO2 emissions from a supplier's trucking delivering goods to your company's warehouse. This presents issues with how to share and validate data across multiple companies.

2.) MRV (measure report validate). Emissions data has to be measured, reported, and validated in a neutral, unobstructed way. Emissions data calculation can include several factors such as material master data in an ERP, current manufacturing processes, weather, and more.

3.) 3rd party verifiability. Additionally - the emissions data and other MRV data can be subject to additional 3rd party auditors such as

Additionally - enterprises face increasing public and private sector pressures to demonstrate increasing commitment to reduce emissions overall while also providing greater granularity and verifiability to any "net zero" and other sustainability claimes they make. It's making a greater impact on business - with many investors or businesses choosing to invest or do business with one enterprise or another with sustainability and ESG rankings being a differentiating factor.

This project allows an organization to deploy a smart contract to mint NFTs representing their carbon emissions data. The tokenization of the carbon emissions data allows organizations to more easily collaborate with 3rd party verifiers to strengthen environmental claims brought to the public. Tokenization can also help ensure proper "net-zero" or other sustainability metrics are attributed to individual products in a proper way.

Additionally - applying the "x to earn" paradigm to this scenario means that governments and business partners could offer additional incentives for enterprises that showcase decreased total GHG emissions in comparision from one time period to another.

## Technical Overview

This project assumes the following workflow aspects for tokenization of emissions data.

An enteprise deploys the emissionsNFT contract. The contract deployer assigns the data steward role to their personell and internal systems to marshall the data into carbon emissions NFTs.

The mint of the NFT takes place first - with the data stewards appending the related emissions data to the token thereafter.

The data stewards are responsible for responding to requests of emissions verifiers that are both internal to their own company as well as external 3rd party verifiers.

Some adjustments of the emissions data for the token are permitted to account for some aspects of human or system related error, but these are tracked!

Once tokenized emissions data is finalized - emissions verifiers can record digital signatures attesting the the emissions data completeness and accuracy. Meeting thresholds of a certain volume of verified GHG emissions data creates the foundation around various business or tax incentives.

Additional public, protected, and private data stores can be referenced by the token ID. The emissions verifier can use this data to determine when to affirm the completeness and accuracy of the emissions data.

For emissions data verification - the following prerequisites must be met
- A valid from-datetime and to-datetime specifiy when the GHG emissions occured
- A specific GHG organization is specified. For example this could be a company code in the enterprise's SAP system.
- The emissions scope level is specified. The emissions data has to be specifically named as scope 1, 2, or 3.
- The total CO2 equivalent amount should be non-zero. Note: the amount can be negative! This is to recognize certain businesses that are in fact carbon negative - though a value above zero is more typically expected.


## Sample Integrations
This app relies upon the [GHG Reporting Sample app](https://github.com/fleischr/GHGReportSample) I've written in SAP CAPM Node.js as a model off-chain data source.

### Hardhat details

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

To compile the contract

```shell
npx hardhat compile
```

Deployment

```shell
npx hardhat deploy
```


### Available Deployments
VeChain Testnet : TBD
VeChain Mainnet : TBD

## Disclaimer
DISCLAIMER : This code is still under active development, has not been audited, and therefore is not yet ready for regular production use. See LICENSE for more details.