// Indicamos la version
pragma solidity >=0.4.4 <0.8.9;
pragma experimental ABIEncoderV2;

contract hash{
    
    function calcularHash(string memory _cadena) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_cadena));
        
    }
    
    function calcularHash(string memory _cadena, uint _k, address _direccion) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_cadena, _k, _direccion));
        
    }
}