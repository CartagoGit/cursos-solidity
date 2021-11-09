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
    mapping (address=>address) public map_contractCenter;
    
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
        map_contractCenter[msg.sender] = addressCenterContract;
        //evento
        emit event_newContract(msg.sender, addressCenterContract);
    }
}

// -----------------------------------------------------------------------
// Contrato autogestiobale por el centro de Salud
contract centerContract {
    address public addressContract;
    address public addressCenter;

    constructor(address _center) {
        addressContract = address(this);
        addressCenter = _center;
    }
    
    /*
    // Map que relacione la id con un rsultado de una prueba de OMS_Covid
    mapping (bytes32 => bool) map_covidResult; //Hash[persona] -> true/false
    
    //Map entre el hash y el codigo ipfs
    mapping (bytes32 => string) map_covidIpfs;
    */
    
    // Map para relacionar la persona con los resultados (diagnostico, codigo ipfs)
    mapping (bytes32=> resultCovid) map_resultCovid;
    
    //Estructura de los resultados
    struct resultCovid{
        bool diagnostic;
        string ipfsCode;
    }
    
    //Eventos
    event event_newResult(bool, string);
    
    modifier onlyThisCenter(){
        require(msg.sender==addressCenter, "Solo puede ser controlado por el centro de salud correspondiente");
        _;
    }
    
    // Funcion para emitir un resultado de una prueba covid
    function resultPcrCovid(string memory _idPersona, bool _resultCovid, string memory _ipfsCode) public onlyThisCenter(){
        //Hash de la identificacion de la persona
        bytes32 hash_idPersona = keccak256 (abi.encodePacked(_idPersona));
        
        /*
        //Relacion entre la persona y el resultado covid
        map_covidResult[hash_idPersona] = _resultCovid;
        //Relacion con codigo ipfs
        map_covidIpfs[hash_idPersona] = _ipfsCode
        */
        
        //Relacion del hash de la persona con la estructura de resultados
        map_resultCovid[hash_idPersona] = resultCovid(_resultCovid,_ipfsCode);
        
        //Eventos
        emit event_newResult(_resultCovid,_ipfsCode);
    }
    
    //Funcion que permita la visualizacion de los resultados
    function visualizeResultsCovid(string memory _idPersona) public view returns(string memory, string memory){
        bytes32 hash_idPersona = keccak256 (abi.encodePacked(_idPersona));
        //Retorno de un booleano como un string
        string memory resultTest;
        if (map_resultCovid[hash_idPersona].diagnostic) resultTest = "Positivo";
        else resultTest = "Negativo";
        
        return (resultTest, map_resultCovid[hash_idPersona].ipfsCode);
        
    }
}
