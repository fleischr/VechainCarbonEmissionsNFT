// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VerifySignature {
    /*
     * @dev Verifies if the message was signed by a given address
     * @param _signer The address of the signer
     * @param _message The message that was signed
     * @param _signature The signature to verify (r, s, v format)
     * @return bool indicating whether the signature is valid
     */
    function verify(address _signer, string memory _message, bytes memory _signature)
        public
        pure
        returns (bool)
    {
        // The messageHash is obtained by hashing the message
        bytes32 messageHash = getMessageHash(_message);

        // The ethSignedMessageHash is obtained by prefixing the messageHash
        // with the string `\x19Ethereum Signed Message:\n{message length}`
        // and then hashing it again.
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        // Recover the signer's address from the signature
        address recoveredSigner = recoverSigner(ethSignedMessageHash, _signature);

        // Compare the recovered signer to the expected signer
        return recoveredSigner == _signer;
    }

    /*
     * @dev Generates the hash of the input message
     * @param _message The message to hash
     * @return bytes32 hash of the message
     */
    function getMessageHash(string memory _message)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_message));
    }

    /*
     * @dev Generates the Ethereum signed message hash
     * @param _messageHash Hash of the message
     * @return bytes32 Ethereum signed message hash
     */
    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        // This prefix is needed for a correct recovery of the address from the signature
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    /*
     * @dev Recovers the signer's address from the signature
     * @param _ethSignedMessageHash The Ethereum signed message hash
     * @param _signature The signature to recover the signer from
     * @return address of the signer
     */
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    /*
     * @dev Splits the signature into r, s and v components
     * @param _signature The signature to split
     * @return r, s, and v components of the signature
     */
    function splitSignature(bytes memory _signature)
        internal
        pure
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(_signature.length == 65, "invalid signature length");

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(_signature, 32))
            // second 32 bytes
            s := mload(add(_signature, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(_signature, 96)))
        }

        // Adjust the v value if it's in lower s form
        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "invalid signature 'v' value");
    }
}
