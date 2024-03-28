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

    //Scope 3 verification request
    enum scope3vreqStatusEnum {
        CREATED,
        REJECTED,
        ENLISTED,
        VERIFIED
    }
    struct scope3VerificationRequest {
        uint32 internalID;
        uint256 scope3VReqID;
        address scope3Contract;
        address scope1Contract;
        string scope3GHGOrgID;
        uint32 scope3TokenID;
        string scope1GHGOrgID;
        uint32 scope1TokenID;
        scope3vreqStatusEnum scope3vreqStatus;
    }

    //events
    event ghgOrgCreated(string ghgOrgId);
    event dataStewardAdded(address dataStewardAddress);
    event emissionsVerifierAdded(address verifierDID, string ghgOrgID, string verifyingOrgID);
    event emissionsTokenCreated(address smartContractAddr, uint32 tokenID);
    event emissionsTokenVerified(address smartContractAddr, uint32 tokenID, uint256 adjustmentID, uint256 tokenVerificationID, address verifierDID);
    event reenlistVerifiersForScope3(address scope1ContractAddr, address scope3ContractAddr, string scope1ghgOrgID, string scope3ghgOrgID, uint32 scope1TokenID, uint32 scope3TokenID);
    event scope3referenced(address scope1contract, address scope3contract, string scope1GHGOrgID, string scope3GHGOrgID, uint32 scope1TokenID, uint32 scope3TokenID, uint256 scope1TokenVerificationID);





    //functions

    function getNextTokenID() external view returns (uint32);

    function getAllEmissionsData() external view returns (emissionsData[] memory);

    function getEmissionsDataByTokenID(uint32 _tokenID) external view returns(emissionsData[] memory);

    function getTokenVerifications(uint32 _tokenID) external view returns(emissionsVerification[] memory);

    function requestScope3EmissionsDataVerification(address _destinationContract, string memory _myghgOrgID, string memory _yourghgOrgID, uint32 _myTokenID, uint32 _yourTokenID) external returns(uint256);

    function logScope3VerificationRequests(address _originContract, string calldata _scope3GHGOrgID, string calldata _scope1GHGOrgID, uint32 _scope3TokenID, uint32 _scope1TokenID) external returns (scope3VerificationRequest memory);

    function getScope3VerificationRequest(address _originContract, string calldata _scope3GHGOrgID, string calldata _scope1GHGOrgID, uint32 _scope3TokenID, uint32 _scope1TokenID) external returns (scope3VerificationRequest memory);

    function sendScope3Verification(address _originContract, string calldata _scope3GHGOrgID, string calldata _scope1GHGOrgID, uint32 _scope3TokenID, uint32 _scope1TokenID, uint256 _tokenVerificationID) external returns (scope3VerificationRequest memory);

    function createScope3Verification(uint32 _targetToken, uint256 _tokenVerificationID, address _verifierDID, string memory _message, bytes calldata _verifierSignature, uint256 _verifiedOn, uint16 _currentAdjustmentID) external returns (emissionsVerification memory);

    function pushScope3Verifiers(address _scope3contract, string calldata _scope1GHGOrgID, string calldata _scope3GHGOrgID) external returns (emissionsVerifier memory);
    


}