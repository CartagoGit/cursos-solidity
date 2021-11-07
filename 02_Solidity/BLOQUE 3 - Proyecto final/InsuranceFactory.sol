// SPDX-License-identifier: MIT
pragma solidity >= 0.8.0 <0.8.9;
import "./OperacionesBasicas.sol";
import "./ERC20.Sol";

//Contrato para la compañia de seguros
contract InsuranceFactory is OperacionesBasicas{
    constructor () {
        token = new ERC20Basic(100);
        Insurance = address(this);
        Aseguradora = payable(msg.sender);
    }
    
    //Instancia del contrato token
    ERC20Basic private token;
    
    //Declaracion de las direcciones
    address Insurance;
    address payable public Aseguradora;
    
    address[] DireccionesAsegurados;
    
}