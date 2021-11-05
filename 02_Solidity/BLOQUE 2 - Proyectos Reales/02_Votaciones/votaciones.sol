// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.8.9;

contract votacion{
    //Direccion del propietario del contrato
    address public owner;
    
    //constructor
    constructor(){
        owner=msg.sender;
    }
    
    // Relacion entre el nombre del candidato y el hash de sus datos personales
    mapping (string => bytes32) mapIdCandidato;
    
    //Relacion entre el nombre del candidato y el numero de cantidad_votos
    mapping (string => uint) mapVotosCandidato;
    
    // Lista con candidatos
    string [] candidatos;
    
    // Lista de votantes en hash para que no se sepa quien ha votado y sea unico
    bytes32 [] votantes;
    
    //Funcion para presentar candidatura a las votaciones
    function presentarCandidatura(string memory _nombre, uint _edad, string memory _idPersona) public{
        
        //Comprobar si el candidato es mayor de edad
        require(_edad>18, "El candidato tiene que ser mayor de edad");
        
        //Hash de los datos del candidatos
        bytes32 hash_candidato = keccak256(abi.encodePacked(_nombre, _edad, _idPersona));
        
        //Almacenar el hash de los datos del candidato ligado a su nombre;
        mapIdCandidato[_nombre]=hash_candidato;
        
        //Añadimos al candidato en la lista
        candidatos.push(_nombre);
    }
    
    //Funcion para visualizar los candidatos
    function getCandidatos () public view returns(string[] memory){
        return candidatos;
    }
}