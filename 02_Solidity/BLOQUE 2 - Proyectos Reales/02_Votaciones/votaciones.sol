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
}