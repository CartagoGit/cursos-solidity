//SPDX-License-Identifier: GPL.3.0
pragma solidity >=0.8.8 <=0.9.0;

contract OMS_Covid{

    //Direccion de la OMS
    address public owner;
    
    constructor(){
        owner=msg.sender;
    }

    // Mapping para relacionar los centros de salud (direccion/address) con la validez del sistema de gestion
    mapping (address=> bool) map_validacion_centrosSalud;
    
    //Array de direcciones que almacene los contratos de salud validades
    address [] public direcciones_contrato_salud

    //Eventos
    evento NuevoCentroValidado (address);
    evento NuevoContraro (address, address)

    //Modificador que permita la ejeciucion unicamente a la ONS
    modifier onlyONS(){
        require(msg.sender == owner);
        _;
    }

    //Funcion para validar nuevos centros de salud que pueda autogestionarse


    //Funcion que permita crear un contrato inteligente



}
