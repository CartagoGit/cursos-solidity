// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;
//pragma experimental ABIEncoderV2;

contract notas{
    
    // Direccion del profesor
    address public profesor;
    string my_string = "Joan";
    
    // Constructor
    constructor(){
        profesor = msg.sender;
    }
    
    // Mapping para relacionar el hash de la indentidad del alumno
    mapping (bytes32 => uint) mapNotas;
    
    // Array de alumnos que pidan revision de examenes
    string [] revisiones;
    
    // Eventos
    event event_alumno_evaluado(bytes32, uint);
    event event_revision(string);
    
    //Creamos la funciona para evaluar a los alumnos
    function evaluar(string memory _idAlumno, uint _nota) public onlyProfesor(msg.sender){
        //Hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //Relacion entre el hash de la identificacion del alumno y su nota
        mapNotas[hash_idAlumno] = _nota;
        
        emit event_alumno_evaluado(hash_idAlumno, _nota);
    
    }
    
    // modificador para controlar que solo pueda evaluar el profesor
    modifier onlyProfesor(address _direccion){
        require(profesor==_direccion,"Solo el profesor puede evaluar a los alumnos");
        _;
    }
    
    // Visualizar notas
    function getNotas(string memory _idAlumno) public view returns(uint){
        //Hash del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Nota asociada al hash del alumno
        uint nota_alumno = mapNotas[hash_idAlumno];
        //visualizar la nota_alumno
        return nota_alumno;
    }
    
    //Funcion para pedir una reivsion del examen
    function revisionNota(string memory _idAlumno) public{
        //Almacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);
        emit event_revision(_idAlumno);
    }
    
    //Funcion para ver los alumnos que han solicitado la revision del examen
    function getRevisiones() public view onlyProfesor(msg.sender) returns(string[] memory){
        return revisiones;
    }
    
    
}