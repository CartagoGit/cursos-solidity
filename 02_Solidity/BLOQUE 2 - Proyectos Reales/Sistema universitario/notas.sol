// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.8.9;
//pragma experimental ABIEncoderV2;

contract contractNotas{
    
    // Direccion del profesor
    address public profesor;
    
    // Constructor
    constructor(){
        profesor = msg.sender;
    }
    
    // Mapping para relacionar el hash de la indentidad del alumno
    mapping (bytes32 => uint) mapNotas;
    
    // Array de alumnos que pidan revision de examenes
    string [] revisiones;
    
    // Eventos
    event event_alumno_evaluado(bytes32);
    event event_revision(string);
    
    
}