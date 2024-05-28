// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./verifierContract.sol";
import "./iEmissionsNFT.sol";

contract emissionsNFT is ERC721, iEmissionsNFT {
 address public owner;
 address public anchorContract;
 uint32 latestTokenID;
 bool readyToMint;
 VerifySignature verifier;
 constructor(address _anchorContract) ERC721("EmissionsNFT", "CO2eNFT") {
   owner = msg.sender;
   anchorContract = _anchorContract;
   dataSteward memory defaultDataSteward;
   defaultDataSteward.dataStewardAddress = msg.sender;
   defaultDataSteward.acknowledDataSteward = true;
   dataStewards.push(defaultDataSteward);
   dataStewardsByAddress[msg.sender] = defaultDataSteward;
   latestTokenID = 1;
   readyToMint = false;
 }

 mapping(string => ghgOrganization) private registeredGHGOrg;
 mapping(string => bool) private isGHGOrg;

 emissionsData[] public publicEmissionsDisclosure;
 mapping(uint32 => emissionsData[]) public allPedsByTokenID;
 mapping(uint32 => emissionsData) public latestPedByTokenID;
 mapping(uint32 => emissionsData) public latestVerifiedPedByTokenID;
 
 emissionsVerification[] public publicEmissionsVerifications;
 mapping(uint32 => emissionsVerification[]) public pevsByTokenID;
 mapping(uint32 => emissionsVerification) public latestPevByTokenID;
 
 emissionsVerifier[] public emissionsVerifiers;
 mapping(address => emissionsVerifier) public emissionsVerifiersByAddress;

 dataSteward[] public dataStewards;
 mapping(address => dataSteward) public dataStewardsByAddress;

 //scope3 requests
 scope3VerificationRequest[] public scope3vreqs;

 function determineMintReadiness() public view returns (bool) {
    return readyToMint;
 }

 function mintEmissionsNFT(address _to) public onlyDataSteward {
  require(determineMintReadiness() == true, "Contract is not ready to mint. Please complete configuration");
  require(msg.sender == _to, "Data stewards must own the initial mint");
  latestTokenID++;
 }

 function mint(address _to) private {
  uint32 newTokenID = getNextTokenID();
  _mint(_to, newTokenID);
  emit emissionsTokenCreated(address(this), newTokenID);
  latestTokenID++;
 }

 function defineGHGOrg(string calldata _ghgOrganizationID, string calldata _ghgOrganizationName) public onlyDataSteward {
    ghgOrganization memory definedGHGOrg;
    definedGHGOrg.ghgOrganizationID = _ghgOrganizationID;
    definedGHGOrg.ghgOrganizationName = _ghgOrganizationName;
    registeredGHGOrg[_ghgOrganizationID] = definedGHGOrg;
    readyToMint = true;
 }

// Carbon Emissions Data Maintenance / Data Stewardship
 function addEmissionsData(uint32 _targetToken, uint256 _fromDateTime, uint256 _toDateTime, int256 _co2eAmount, address _emissionsOrigin, bytes32 _publicIPFSCID, bytes32 _protectedIPFSCID, bytes32 _sapcapDataHash, string calldata _emissionsVaultID, string calldata _ghgOrgID, carbonScopeLevel _scopeLevel) public returns (bool) {
    // token must exist
    require(_exists(_targetToken), "Token does not exist!" );

    //validate the from and to timestamp
    require(_toDateTime > _fromDateTime, "from-datetime must be less than to-datetime");

    //ensure a valid configured org id is added
    require(isGHGOrg[_ghgOrgID] == true, "GHG Organization is unknown. Please register it");

    //ensure valid scope level is passed
    require(_scopeLevel <= carbonScopeLevel.Scope3, "Emissions data must be classified as scopes 1-3 or as unknown(0)");
    
    uint32 targetToken = _targetToken;
    emissionsData[] memory pedsByTokenID;
    pedsByTokenID = allPedsByTokenID[targetToken];
    //see if this emissions data was already maintained
    if(pedsByTokenID.length == 0) {
        emissionsData memory newEmissionsData;
        newEmissionsData.tokenID = targetToken;
        newEmissionsData.fromDateTime = _fromDateTime;
        newEmissionsData.toDateTime = _toDateTime;
        newEmissionsData.co2eAmount = _co2eAmount;
        newEmissionsData.emissionsOrigin = _emissionsOrigin;
        newEmissionsData.publicIPFSCID = _publicIPFSCID;
        newEmissionsData.protectedIPFSCID = _protectedIPFSCID;
        newEmissionsData.sapcapDataHash = _sapcapDataHash;
        newEmissionsData.emissionsVaultID = _emissionsVaultID;
        newEmissionsData.reportingGHGOrgID = _ghgOrgID;
        newEmissionsData.adjustmentID = 0;
        publicEmissionsDisclosure.push(newEmissionsData);
        latestPedByTokenID[targetToken] = newEmissionsData;
    } else {
        emissionsData storage existingEmissionsData = latestPedByTokenID[targetToken];
        require(existingEmissionsData.fromDateTime == _fromDateTime, "From Date Time must remain the same");
        require(existingEmissionsData.toDateTime == _toDateTime, "To Date Time must remain the same");
        int256 adjustedCO2Eamount = _co2eAmount;
        address adjustedEmissionsOrigin = _emissionsOrigin;
        bytes32 adjustedPublicIPFSCID = _publicIPFSCID;
        bytes32 adjustedProtectedIPFSCID = _protectedIPFSCID;
        bytes32 adjustedSAPCAPdatahash = _sapcapDataHash;
        string calldata adjustedEmissionsVaultID = _emissionsVaultID;
        string calldata adjustedGHGOrg = _ghgOrgID;
        carbonScopeLevel adjustedScopeLevel = _scopeLevel;
        adjustEmissionsData(existingEmissionsData.fromDateTime, existingEmissionsData.toDateTime, targetToken, adjustedCO2Eamount, adjustedEmissionsOrigin, adjustedPublicIPFSCID, adjustedProtectedIPFSCID, adjustedSAPCAPdatahash, adjustedEmissionsVaultID, adjustedGHGOrg, adjustedScopeLevel);
    }
    return true;
 }
 function adjustEmissionsData(uint256 _fromDateTime, uint256 _toDateTime, uint32 _targetToken, int256 _co2eAmount, address _emissionsOrigin, bytes32 _publicIPFSCID, bytes32 _protectedIPFSCID, bytes32 _sapcapDataHash, string calldata _emissionsVaultID, string calldata _ghgOrgID, carbonScopeLevel _scopeLevel) private returns (bool) {
        emissionsData memory adjustedEmissionsData;
        adjustedEmissionsData.tokenID = _targetToken;
        adjustedEmissionsData.fromDateTime = _fromDateTime;
        adjustedEmissionsData.toDateTime = _toDateTime;
        adjustedEmissionsData.co2eAmount = _co2eAmount;
        adjustedEmissionsData.emissionsOrigin = _emissionsOrigin;
        adjustedEmissionsData.publicIPFSCID = _publicIPFSCID;
        adjustedEmissionsData.protectedIPFSCID = _protectedIPFSCID;
        adjustedEmissionsData.sapcapDataHash = _sapcapDataHash;
        adjustedEmissionsData.emissionsVaultID = _emissionsVaultID;
        adjustedEmissionsData.reportingGHGOrgID = _ghgOrgID;
        adjustedEmissionsData.scopeLevel = _scopeLevel;
        adjustedEmissionsData.adjustmentID = allPedsByTokenID[_targetToken].length;
        publicEmissionsDisclosure.push(adjustedEmissionsData);
        return true;
 }

 //Carbon Emissions Data Verification
 function addEmissionsVerification(uint32 _targetToken, uint256 _tokenVerificationID, address _verifierDID, string memory _message, bytes calldata _verifierSignature, uint256 _verifiedOn, uint16 _currentAdjustmentID) public onlyEmissionsVerifier {
   bool isValidVerification = false;
   isValidVerification = verifier.verify(_verifierDID, _message, _verifierSignature);
   require(isValidVerification == true, "Emission Data Verification is invalid");

   emissionsVerification memory newPEV;
   newPEV.tokenID = _targetToken;
   newPEV.verifierDID = _verifierDID;
   newPEV.verifierSignature = _verifierSignature;
   newPEV.verifiedOnDateTime1 = _verifiedOn;
   newPEV.verifiedOnDateTime2 = block.timestamp; 
   newPEV.currentAdjustmentID = _currentAdjustmentID;
   publicEmissionsVerifications.push(newPEV);
   pevsByTokenID[_targetToken].push(newPEV);
   latestPevByTokenID[_targetToken] = newPEV;
   emit emissionsTokenVerified(address(this), _targetToken, _currentAdjustmentID, _tokenVerificationID, _verifierDID);
 }

 function getTokenVerifications(uint32 _tokenID) external view returns(emissionsVerification[] memory){
  emissionsVerification[] memory emissionsVerificationByToken;
  emissionsVerificationByToken = pevsByTokenID[_tokenID];
  return emissionsVerificationByToken;
 }

 function requestVerifierRole(address _requestedVerifierDID, string calldata _ghgOrgID) public{
    emissionsVerifier memory requestedVerifier;
    requestedVerifier.emissionsVerifierAddress = _requestedVerifierDID;
    requestedVerifier.requestedBy = msg.sender;
    requestedVerifier.acknowledgedVerifer = false;
    requestedVerifier.subjectGHGOrgID = _ghgOrgID;
    emissionsVerifiersByAddress[_requestedVerifierDID] = requestedVerifier;
 }

 function approveVerifierRole(address _verifierDID, string calldata _ghgOrgID) public onlyAuthority {
   require(_verifierDID != msg.sender, "Sorry. Cannot self-approve verifier role.");
   emissionsVerifier storage approvedVerifier = emissionsVerifiersByAddress[_verifierDID];
   approvedVerifier.acknowledgedVerifer = true;
   approvedVerifier.acknowledgedOn = block.timestamp;
   approvedVerifier.addedBy = msg.sender;
   approvedVerifier.subjectGHGOrgID = _ghgOrgID;
   emissionsVerifiersByAddress[_verifierDID] = approvedVerifier;
 }

 function autoApproveDataSteward(address _newDataSteward, string calldata _ghgOrgID) external returns (bool) {
    require(msg.sender == owner, "Only the contract owner may do this");
    dataSteward memory autoApproved;
    autoApproved.dataStewardAddress = _newDataSteward;
    autoApproved.addedBy = msg.sender;
    autoApproved.acknowledDataSteward = true;
    autoApproved.ghgOrgID = _ghgOrgID;
    dataStewards.push(autoApproved);
    dataStewardsByAddress[_newDataSteward] = autoApproved;
    return true;
 }


 function getNextTokenID() public view returns (uint32){
   return latestTokenID;
 }

 function getAllEmissionsData() external view returns (emissionsData[] memory){}

 function getEmissionsDataByTokenID(uint32 _tokenID) external view returns(emissionsData[] memory){
   return allPedsByTokenID[_tokenID];
 }

 /*function requestScope3EmissionsDataVerification(address _destinationContract, string memory _myghgOrgID, string memory _yourghgOrgID, uint32 _myTokenID, uint32 _yourTokenID) external returns(uint256){
    // get the remote contract instance
    iEmissionsNFT remoteContract = iEmissionsNFT(_destinationContract);
    uint256 scope3DVTicket = 0;
    try remoteContract.logScope3VerificationRequests(address(this), _myghgOrgID, _yourghgOrgID, _myTokenID, _yourTokenID) {
      return scope3DVTicket;
    } catch {
      return scope3DVTicket;
    }
 }*/

 /*function logScope3VerificationRequests(address _originContract, string calldata _scope3GHGOrgID, string calldata _scope1GHGOrgID, uint32 _scope3TokenID, uint32 _scope1TokenID) external returns (scope3VerificationRequest memory){
    scope3VerificationRequest memory inboundRequest;
    inboundRequest.scope1Contract = address(this);
    inboundRequest.scope3Contract = _originContract;
    inboundRequest.scope3GHGOrgID = _scope3GHGOrgID;
    inboundRequest.scope1GHGOrgID = _scope1GHGOrgID;
    inboundRequest.scope1TokenID = _scope1TokenID;
    inboundRequest.scope3TokenID = _scope3TokenID;
    inboundRequest.scope3vreqStatus = scope3vreqStatusEnum.CREATED;
    scope3vreqs.push(inboundRequest);
    return inboundRequest;
 }*/

 /*function getScope3VerificationRequest(address _originContract, string calldata _scope3GHGOrgID, string calldata _scope1GHGOrgID, uint32 _scope3TokenID, uint32 _scope1TokenID) external returns (scope3VerificationRequest memory){
   scope3VerificationRequest memory myScope3Request;
   iEmissionsNFT remoteContract = iEmissionsNFT(_originContract);
   //myScope3Request = iEmissionsNFT.getScope3VerificationRequest(_originContract, _scope3GHGOrgID, _scope1GHGOrgID, _scope3TokenID, _scope1TokenID);
   return myScope3Request;
 }*/

 /*function sendScope3Verification(address _originContract, string calldata _scope3GHGOrgID, string calldata _scope1GHGOrgID, uint32 _scope3TokenID, uint32 _scope1TokenID, uint256 _tokenVerificationID) external returns (scope3VerificationRequest memory) {
    iEmissionsNFT remoteContract = iEmissionsNFT(_originContract);
    //remoteContract.createScope3Verification(_scope3TokenID, _tokenVerificationID, _verifierDID, _message, _verifierSignature, _verifiedOn, _currentAdjustmentID);
    scope3VerificationRequest memory returnedRequest;
    address myContractAddress = address(this);
    //returnedRequest = iEmissionsNFT.getScope3VerificationRequest(myContractAddress, _scope3GHGOrgID, _scope1GHGOrgID, _scope3TokenID, _scope1TokenID);
    //remoteContract.createScope3Verification(_targetToken, _tokenVerificationID, _verifierDID, _message, _verifierSignature, _verifiedOn, _currentAdjustmentID);
    return returnedRequest;
 }*/

 /*function createScope3Verification(uint32 _targetToken, uint256 _tokenVerificationID, address _verifierDID, string memory _message, bytes calldata _verifierSignature, uint256 _verifiedOn, uint16 _currentAdjustmentID) external returns (emissionsVerification memory) {
    addEmissionsVerification(_targetToken, _tokenVerificationID, _verifierDID, _message, _verifierSignature, _verifiedOn, _currentAdjustmentID); 
 }*/

 /*function pushScope3Verifiers(address _scope3contract, string calldata _scope1GHGOrgID, string calldata _scope3GHGOrgID) external returns (emissionsVerifier memory) {
    //get the verifiers for the scope 1 token
 }*/

 /*function shareAddress() external view returns(address) {
    return address(this);
 }*/

 //Role-based modifiers
 modifier onlyEmissionsVerifier() {
   emissionsVerifier memory emissionsVerifierLookup = emissionsVerifiersByAddress[msg.sender];
   require(emissionsVerifierLookup.acknowledgedVerifer == true, "Emissions Verifier Role needs approval");
   _;
 }

 modifier onlyDataSteward() {
   dataSteward memory dataStewardLookup = dataStewardsByAddress[msg.sender];
   require(dataStewardLookup.acknowledDataSteward == true, "Data steward role needs approval");
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
   emissionsVerifier memory emissionsVerifierLookup = emissionsVerifiersByAddress[msg.sender];
   dataSteward memory dataStewardLookup = dataStewardsByAddress[msg.sender];
   if(emissionsVerifierLookup.acknowledgedVerifer == true || dataStewardLookup.acknowledDataSteward == true){
      isAuthority = true;
   }
   require(isAuthority == true, "Data steward or emissions verifier role needs approval");
   _;
 }
}
