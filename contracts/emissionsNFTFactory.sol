// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./emissionsNFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract emissionsNFTFactory {
    emissionsNFT[] public deployedNFTs;
    IERC20 public paymentToken;
    uint256 public creationFee;

    mapping(address => emissionsNFT) public emissionsNFTByDeployer;

    constructor() {
        //paymentToken = _paymentToken;
        //creationFee = _creationFee;
    }

    function createNFT() public returns(emissionsNFT) {
       //require(paymentToken.transferFrom(msg.sender, address(this), creationFee),
       //     "Failed to transfer creation fee");

        emissionsNFT newNFT = new emissionsNFT(address(this));
        deployedNFTs.push(newNFT);
        emissionsNFTByDeployer[msg.sender] = newNFT;
        return newNFT;
    }

    function getDeployedNFTs() public view returns (emissionsNFT[] memory) {
        return deployedNFTs;
    }
}