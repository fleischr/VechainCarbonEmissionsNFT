// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./emissionsNFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTFactory {
    emissionsNFT[] public deployedNFTs;
    IERC20 public paymentToken;
    uint256 public creationFee;

    mapping(address => emissionsNFT) public emissionsNFTByDeployer;

    constructor(IERC20 _paymentToken, uint256 _creationFee) {
        paymentToken = _paymentToken;
        creationFee = _creationFee;
    }

    function createNFT() public {
        require(paymentToken.transferFrom(msg.sender, address(this), creationFee),
            "Failed to transfer creation fee");

        emissionsNFT newNFT = new emissionsNFT();
        deployedNFTs.push(newNFT);
        emissionsNFTByDeployer[msg.sender] = newNFT;
    }

    function getDeployedNFTs() public view returns (emissionsNFT[] memory) {
        return deployedNFTs;
    }
}