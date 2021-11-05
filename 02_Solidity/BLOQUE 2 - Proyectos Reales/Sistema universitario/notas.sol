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
    
    //Creamos la funciona para evaluar a los alumnos
    function evaluar(string memory _idAlumno, uint _nota) public onlyProfesor(msg.sender){
        //Hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(bytes(_idAlumno));
        //Relacion entre el hash de la identificacion del alumno y su nota
        mapNotas[hash_idAlumno] = _nota;
        
        emit event_alumno_evaluado(hash_idAlumno);
    
    }
    
    modifier onlyProfesor(address _direccion){
        require(profesor==_direccion,"Solo el profesor puede evaluar a los alumnos");
        _;
    }
    
}