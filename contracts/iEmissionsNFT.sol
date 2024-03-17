// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface iEmissionsNFT {
    enum carbonScopeLevel {
        Unknown,
        Scope1,
        Scope2,
        Scope3
    }

     //GHG Organization
    struct ghgOrganization {
        string ghgOrganizationID;
        string ghgOrganizationName;
        bytes privateHash;
    }

    //Tokenized Carbon Emissions Data
    struct emissionsData {
        uint32 tokenID;
        uint256 fromDateTime;
        uint256 toDateTime;
        int256 co2eAmount;
        address emissionsOrigin;
        bytes32 publicIPFSCID;
        bytes32 protectedIPFSCID;
        bytes32 sapcapDataHash;
        string emissionsVaultID;
        uint256 adjustmentID;
        string reportingGHGOrgID;
        carbonScopeLevel scopeLevel;
    }

     //Carbon Emissions Verification
    struct emissionsVerification {
        uint32 tokenID;
        uint16 tokenVerificationID;
        address verifierDID;
        bytes verifierSignature;
        uint256 verifiedOnDateTime1;
        uint256 verifiedOnDateTime2;
        uint16 verificationCount;
        uint16 currentAdjustmentID;
    }

     //Carbon Emissions Verifiers
    struct emissionsVerifier {
        address emissionsVerifierAddress;
        bool acknowledgedVerifer;
        address requestedBy;
        address addedBy;
        string subjectGHGOrgID;
        string verificationOrgID;
        uint256 acknowledgedOn;
    }

     //Carbon Emissions Data Stewards
    struct dataSteward {
        address dataStewardAddress;
        bool acknowledDataSteward;
        address addedBy;
        string ghgOrgID;
    }
}