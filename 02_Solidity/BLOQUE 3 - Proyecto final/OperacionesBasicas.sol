// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.9;
import "./SafeMath.sol";

abstract contract OperacionesBasicas{
    using SafeMath for uint256;
    
    //Contrato abstracto
    constructor () {}
    
    function calcularPrecioTokens(uint _numTokens) internal pure returns (uint){
        return _numTokens.mul(1 ether);
    }
    
    function getBalance() public view returns(uint ethers){
        return payable(address(this)).balance;
    }
    
    // uint to str para versiones posteriores a 0.8.0; mas info en el archivo correspondiente en recursos del curso.
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    
}