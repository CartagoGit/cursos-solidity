pragma solidity >=0.4.4 <0.8.9;
pragma experimental ABIEncoderV2;

contract Mappings{
    
    //Declaramos un mapping para elegir un numero
    mapping (address => uint) public mapElegirNumero;
    
    function elegirNumero(uint _numero) public{
        mapElegirNumero[msg.sender] = _numero;
    }
    
    function consultarNumero () public view returns(uint){
        return mapElegirNumero[msg.sender];
    }

    // Declaramos un mapping que relaciona el nombre de una persona con su cantidad de dinero
    mapping(string => uint ) mapCantidadDinero;

    function elegirDinero(string memory _nombre, uint _dinero) public{
        mapCantidadDinero[_nombre] =_dinero;
    }

    function consultarDinero(string memory _nombre) public view returns(uint){
        return mapCantidadDinero[_nombre];
    }

    // Ejemplo de mapping con un tipo de dato complejo
    struct Persona{
        string nombre;
        uint edad;
    }

    mapping(uint => Persona)mapPersonas;

    function dni_Persona(uint _numeroDni, string memory _nombre, uint _edad)public{
        mapPersonas[_numeroDni] = Persona(_nombre, _edad);
    }

    function  visualizarPersona(uint _dni) public view returns (Persona memory){
        return mapPersonas[_dni];
    }
}