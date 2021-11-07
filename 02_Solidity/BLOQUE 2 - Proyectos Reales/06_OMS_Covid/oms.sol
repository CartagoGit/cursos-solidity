// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.9.0;

contract OMS_Covid {
    //Direccion de la OMS
    address public owner;


    constructor() {
        owner = msg.sender;
    }

    // Mapping para relacionar los centros de salud (direccion/address) con la validez del sistema de gestion
    mapping(address => bool) public map_validatedCenters;
    //Relacionar una direccion de un Centro de Salud con su contrato
    mapping (address=>address) public map_ContractCenter;
    
    //Array de direcciones que almacene los contratos de salud validados
    address[] public arr_contractCenters;
    //Array de solicitudes de los centros para crear un contrato para el centros
    address[] arr_requestContract;

    //Eventos
    event event_requestContract(address);
    event event_newValidatedCenter(address);
    event event_newContract(address, address);

    //Modificador que permita la ejeciucion unicamente a la ONS
    modifier onlyOMS() {
        require(msg.sender == owner, "Solo puede ejecutarlo la OMS");
        _;
    }
    
    
    //Funcion para que el centro solicite un contrato
    function requestContract() public {
        arr_requestContract.push(msg.sender);
        emit event_requestContract(msg.sender);
    }

    //Funcion para poder ver las solicitudes
    function visualizeRequests() public view onlyOMS returns (address[] memory)
    {
        return arr_requestContract;
    }

    //Funcion para validar nuevos centros de salud que pueda autogestionarse
    function validateCenter(address _center) public onlyOMS {
        map_validatedCenters[_center] = true;
        emit event_newValidatedCenter(_center);
    }

    //Funcion que permita crear un contrato inteligente
    function createContracts() public {
        require(map_validatedCenters[msg.sender],"El centro de salud no tiene permiso para crear el contrato");
        address addressCenterContract = address(new centerContract(msg.sender));
        //Almacenamos la direccion del nuevo contrato en el array
        arr_contractCenters.push(addressCenterContract);
        // Relacion entre el centro de salud y su contrato;
        map_ContractCenter[msg.sender] = addressCenterContract;
        //evento
        emit event_newContract(msg.sender, addressCenterContract);
    }
}

// -----------------------------------------------------------------------
// Contrato autogestiobale por el centro de Salud
contract centerContract {
    address addressContract;
    address addressCenter;

    constructor(address _center) {
        addressContract = address(this);
        addressCenter = _center;
    }
    
    // Map que relacione la id con un rsultado de una prueba de OMS_Covid
    mapping (bytes32 => bool) map_covidResult; //Hash[persona] -> true/false
    
    //Map entre el hash y el codigo ipfs
    mapping (bytes32 => string) map_covidIpfs;
    
    //Eventos
    event event_newResult(string, bool);
    
    modifier onlyThisCenter(){
        require(msg.sender==addressCenter, "Solo puede ser controlado por el centro de salud correspondiente");
        _;
    }
}
