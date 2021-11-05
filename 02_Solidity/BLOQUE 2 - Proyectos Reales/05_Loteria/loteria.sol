// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.0 <=8.9.0;

import "./ERC20.sol";


contract loteria {
    ERC20Basic private token;
    
    // Direcciones
    address public owner;
    address public contrato;
    
    // Numero de tokens a crear
    uint public tokens_creados = 10000000;
    
    //constructor
    constructor (){
        token = new ERC20Basic(tokens_creados);
        owner = msg.sender;
        contrato = address(this);
    }
    
    // ------------------------------------ TOKEN ---------------------------------
    
    //Establecer el precio de los tokens en ethers
    function precioTokens(uint _numTokens) internal pure returns (uint){
        return _numTokens*(1 ether);
    }
    
    
    
}

