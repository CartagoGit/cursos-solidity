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
    
    //Funcion para votar
    function votar(string memory _candidato) public {
        //Calculamos el hash de la persona que ejecuta esa funcion
        bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));
        
        //Verificamos si el votante ya ha votado
        for(uint i=0; i<votantes.length; i++){
            require(votantes[i]!=hash_votante, "Ya has votado. No puedes votar mas veces");
        }
        //Almacenamos el has del votante y añadimos su voto al candidato
        votantes.push(hash_votante);
        mapVotosCandidato[_candidato]++;
    }
    
    // Ver la cantidad de votos que tiene un candidato
    function getVotosCandidato(string memory _candidato) public view returns(uint){
        return mapVotosCandidato[_candidato];
    }
    
    //Funcion auxiliar para convertir un int a string adaptada a >=0.8.0
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    
    //funcion para ver el resultado de las votaciones
    function resultadoVotaciones () public view returns(string[] memory){
        uint numCandidatos = candidatos.length;
        //string [numCandidatos-1] memory resultados;
        string[] memory resultados = new string[] (numCandidatos);
        for(uint i=0; i<candidatos.length; i++){
            resultados[i] = string(abi.encodePacked(candidatos[i],": ", uint2str(getVotosCandidato(candidatos[i]))));
            }
        return resultados;
        
    }

}