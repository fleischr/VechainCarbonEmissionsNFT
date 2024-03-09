// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import verifierContract from "./verifierContract.sol";

contract emissionsNFT is ERC721 {
 address public owner;
 uint32 latestTokenID;
 bool readyToMint;
 constructor() ERC721("EmissionsNFT", "CO2eNFT") {
   owner = msg.sender;
   defaultDataSteward = new dataSteward();
   defaultDataSteward.dataStewardAddress = msg.sender;
   defaultDataSteward.acknowledDataSteward = true;
   dataStewards.push(defaultDataSteward);
   dataStewardAddress[msg.sender] = defaultDataSteward;
   latestTokenID = 1;
   readyToMint = false;
 }

enum carbonScopeLevel {
  Unknown,
  Scope1,
  Scope2,
  Scope3
}

 //GHG Organization
 struct ghgOrganization {
    string ghgOrganizationID,
    string ghgOrganizationName,
    bytes privateHash,
 }
 mapping(string => ghgOrganization) public registeredGHGOrg;

 //Tokenized Carbon Emissions Data
 struct emissionsData {
    uint32 tokenID,
    uint256 fromDateTime,
    uint256 toDateTime,
    int256 co2eAmount,
    address emissionsOrigin,
    bytes32 publicIPFSCID,
    bytes32 protectedIPFSCID,
    bytes32 sapcapDataHash,
    string emissionsVaultID,
    uint16 adjustmentID,
    string reportingGHGOrgID,
    carbonScopeLevel scopeLevel,
 }
 emissionsData[] public publicEmissionsDisclosure;
 mapping(uint32 => emissionsData) public latestePedByTokenID;
 mapping(uint32 => emissionsData) public latestVerifiedPedByTokenID;
 
 //Carbon Emissions Verification
 struct emissionsVerification {
    uint32 tokenID,
    uint16 tokenVerificationID,
    address verifierDID,
    bytes verifierSignature,
    uint256 verifiedOnDateTime,
    uint16 verificationCount,
    uint16 currentAdjustmentID,
 }
 emissionsVerification[] public publicEmissionsVerifications;
 mapping(uint32 => emissionsVerification) public latestPevByTokenID;
 
 //Carbon Emissions Verifiers
 struct emissionsVerifier {
   address emissionsVerifierAddress,
   bool acknowledgedVerifer,
   address addedBy,
   string subjectGHGOrgID,
   string verificationOrgID,
 }
 emissionsVerifier[] public emissionsVerifiers;
 mapping(address => emissionsVerifier) public emissionsVerifiersByAddress;

 //Carbon Emissions Data Stewards
 struct dataSteward {
   address dataStewardAddress,
   bool acknowledDataSteward,
   address addedBy,
   string ghgOrgID,
 }
 dataSteward[] public dataStewards;
 mapping(address => dataSteward) public dataStewardsByAddress;

 function mintEmissionsNFT(address _to) onlyDataSteward {
  require(readyToMint == true, "Contract is not ready to mint. Please complete configuration");
  require(msg.sender == _to, "Data stewards must own the initial mint");
  latestTokenID++;
 }

 function mint(address _to, uint32 _tokenID) {
  _mint(_to, _tokenID);
 }

 function defineGHGOrg(string _ghgOrganizationID, string _ghgOrganizationName) onlyDataSteward {
    definedGHGOrg = new ghgOrganization();
    definedGHGOrg.ghgOrganizationID = _ghgOrganizationID;
    definedGHGOrg.ghgOrganizationName = _ghgOrganizationName;
    registeredGHGOrg[_ghgOrganizationID] = definedGHGOrg;
 }

// Carbon Emissions Data Maintenance / Data Stewardship
 function addEmissionsData(uint32 _targetToken, uint256 _fromDateTime, uint256 _toDateTime, int256 _co2eAmount, address _emissionsOrigin, bytes32 _publicIPFSCID, bytes32 _protectedIPFSCID, bytes32 _sapcapDataHash, string _emissionsVaultID, string _ghgOrgID, uint _scopeLevel) {
    // token must exist
    require(_exists(_targetToken), "Token does not exist!" );

    //validate the from and to timestamp
    require(_toDateTime > _fromDateTime, "from-datetime must be less than to-datetime");

    //ensure a valid configured org id is added
    require(registeredGHGOrg[_ghgOrgID], "GHG Organization is unknown. Please register it");

    //ensure valid scope level is passed
    require(_scopeLevel <= carbonScopeLevel.Scope3, "Emissions data must be classified as scopes 1-3 or as unknown(0)");
    
    //see if this emissions data was already maintained
    if(pedsByToken[_targetToken].length == 0) {
        newEmissionsData = new emissionsData();
        newEmissionsData.tokenID = _targetToken;
        newEmissionsData.fromDateTime = _fromDateTime;
        newEmissionsData.toDateTime = _toDateTime;
        newEmissionsData.co2eAmount = _co2eAmount;
        newEmissionsData.emissionsOrigin = _emissionsOrigin;
        newEmissionsData.publicIPFSCID = _publicIPFSCID;
        newEmissionsData.protectedIPFSCID = _protectedIPFSCID;
        newEmissionsData.sapcapDataHash = _sapcapDataHash;
        newEmissionsData.emissionsVaultID = _emissionsVaultID;
        newEmissionsData.ghgOrganizationID = _ghgOrgID;
        newEmissionsData.adjustmentID = 0;
        publicEmissionsDisclosure.push(newEmissionsData);
    } else {
        existingEmissionsData = pedsByToken[_targetToken];
        require(existingEmissionsData.fromDateTime == _fromDateTime, "From Date Time must remain the same");
        require(existingEmissionsData.toDateTime == _toDateTime, "To Date Time must remain the same");
        adjustEmissionsData(_targetToken, _co2eAmount, _emissionsOrigin, _protectedIPFSCID, _protectedIPFSCID, _sapcapDataHash, _emissionsVaultID);
    }

 }
 function adjustEmissionsData(uint32 _targetToken, int256 _co2eAmount, address _emissionsOrigin, bytes32 _publicIPFSCID, bytes32 _protectedIPFSCID, bytes32 _sapcapDataHash, string _emissionsVaultID) {
        adjustedEmissionsData = new emissionsData();
        adjustedEmissionsData.tokenID = _targetToken;
        adjustedEmissionsData.fromDateTime = _fromDateTime;
        adjustedEmissionsData.toDateTime = _toDateTime;
        adjustedEmissionsData.co2eAmount = _co2eAmount;
        adjustedEmissionsData.emissionsOrigin = _emissionsOrigin;
        adjustedEmissionsData.publicIPFSCID = _publicIPFSCID;
        adjustedEmissionsData.protectedIPFSCID = _protectedIPFSCID;
        adjustedEmissionsData.sapcapDataHash = _sapcapDataHash;
        adjustedEmissionsData.emissionsVaultID = _emissionsVaultID;
        adjustedEmissionsData.ghgOrganizationID = _ghgOrgID;
        adjustedEmissionsData.adjustmentID = pedsByToken[_targetToken].length;
        publicEmissionsDisclosure.push(adjustedEmissionsData);
 }

 //Carbon Emissions Data Verification
 function addEmissionsVerification(uint32 _targetToken, uint16 _tokenVerificationID, address _verifierDID, string memory _message, bytes _verifierSignature, uint256 _verifiedOn, uint16 _currentAdjustmentID) onlyEmissionsVerifier {
   bool isValidVerification = false;
   isValidVerification = verifierContract.verify(_verifierDID, _message, _verifierSignature);
   require(isValidVerification == true, "Emission Data Verification is invalid");

   newPEV = new emissionsVerification();
   newPEV.tokenID = _targetToken;
   //newPEV.tokenVerificationID 
   newPEV.verifierDID = _verifierDID;
   newPEV.verifierSignature = _verifierSignature;
   newPEV.verifiedOnDateTime = block.timestamp; 
   newPEV.currentAdjustmentID = _currentAdjustmentID;
 }

 function requestVerifierRole(address _requestedVerifierDID){

 }

 function approveVerifierRole(address _verifierDID){
   emissionsVerifier approvedVerifier = emissionsVerifiersByAddress[_verifierDID];

 }

 //Role-based modifiers


 modifier onlyEmissionsVerifier() {
   emissionsVerifierLookup = emissionsVerifiersByAddress[msg.sender];
   require(emissionsVerifierLookup.acknowledDataSteward == true, "Emissions Verifier Role needs approval");
   _;
 }

 modifier onlyDataSteward() {
   dataStewardLookup = dataStewardsByAddress[msg.sender];
   require(dataStewardLookup.acknowledDataSteward == true, "Data steward role needs approval")
   _;
 }
 
 //Smart contract owner
 modifier onlyOwner() {
   require(msg.sender == owner, "Only the contract owner may do this");
   _;
 }

 //either data stewards or emissions verifiers
 modifier onlyAuthority() {
   bool isAuthority = false;
   emissionsVerifierLookup = emissionsVerifiersByAddress[msg.sender];
   dataStewardLookup = dataStewardsByAddress[msg.sender];
   if(emissionsVerifierLookup.acknowledDataSteward == true || dataStewardLookup.acknowledDataSteward == true){
      isAuthority = true;
   }
   require(isAuthority == true, "Data steward or emissions verifier role needs approval");
 }
}
