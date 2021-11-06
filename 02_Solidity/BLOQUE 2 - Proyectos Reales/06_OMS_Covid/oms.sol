//SPDX-License-Identifier: GPL.3.0
pragma solidity >=0.8.0 <=0.9.0;
contract OMS_Covid{

    //Direccion de la OMS
    address public owner;

    constructor () {
        owner = msg.sender;
    }

    // Mapping para relacionar los centros de salud (direccion/address) con la validez del sistema de gestion
    mapping (address=> bool) map_validated_centers;

    //Array de direcciones que almacene los contratos de salud validados
    address[] public contract_centers;

    //Eventos
    event event_NuevoCentroValidado(address);
    event event_NuevoContraro(address, address);

    //Modificador que permita la ejeciucion unicamente a la ONS
    modifier onlyOMS(){
        require(msg.sender == owner, "Solo puede ejecutarlo la OMS");
        _;
    }

    //Funcion para validar nuevos centros de salud que pueda autogestionarse
    function validateCenter(address _center) public onlyOMS(){
        map_validated_centers[_center] = true;
    }

    //Funcion que permita crear un contrato inteligente



}
