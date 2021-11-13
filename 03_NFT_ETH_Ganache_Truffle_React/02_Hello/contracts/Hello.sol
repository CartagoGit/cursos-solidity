// SPDX-License-Identifier: MIN
pragma solidity >=0.8.0 <=0.8.10;

contract Hello {
    string public message = "Hola Mundo";

    function getMessage() public view returns (string memory) {
        return message;
    }

    function setMessage(string memory _message) public {
        message = _message;
    }
}
