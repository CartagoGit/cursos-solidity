//SPDX-License-Identifier: GPL.3.0
pragma solidity >=0.8.0 <=0.9.0;
contract OMS_Covid{

    //Direccion de la OMS
    address public owner;

    constructor () {
        owner = msg.sender;
    }

    // Mapping para relacionar los centros de salud (direccion/address) con la validez del sistema de gestion
    mapping (address=> bool) map_validatedCenters;

    //Array de direcciones que almacene los contratos de salud validados
    address[] public arr_contractCenters;

    //Eventos
    event event_newValidatedCenter(address);
    event event_newContract(address, address);

    //Modificador que permita la ejeciucion unicamente a la ONS
    modifier onlyOMS(){
        require(msg.sender == owner, "Solo puede ejecutarlo la OMS");
        _;
    }

    //Funcion para validar nuevos centros de salud que pueda autogestionarse
    function validateCenter(address _center) public onlyOMS(){
        map_validatedCenters[_center] = true;
        emit event_newValidatedCenter(_center);
    }

    //Funcion que permita crear un contrato inteligente
    function createContracts() public {
        require(map_validatedCenters[msg.sender], "El centro de salud no tiene permiso para crear el contrato");
        address addressCenterContract = address (new centerContract(msg.sender));
        //Almacenamos la direccion del nuevo contrato en el array
        arr_contractCenters.push(addressCenterContract);
        //evento
        emit event_newContract(msg.sender, addressCenterContract);
    }
}

// -----------------------------------------------------------------------
contract centerContract{

    address addressContract;
    address addressCenter;
    constructor(address _center){
        addressContract = address(this);
        addressCenter = _center;
    }
}
