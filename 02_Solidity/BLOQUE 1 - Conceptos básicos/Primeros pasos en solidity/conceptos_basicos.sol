// Indicamos la version
pragma solidity >=0.4.0 <0.8.9;
// Importamos el archivo ERC20.sol que esta en el directorio de trabajo
import "./ERC20.sol";

/// @notice Lo que hace el contrato o su funcionalidad (en formato natspec, recomendado para publicar contratos)
contract PrimerContrato {
    //En esta variable se encuentra la direccion de la persona que despliega elcontrato
    address owner;
    ERC20Basic token;

    /*
    Guardamo en la variable owner la direccion de la persona que despliega el contrato y ademas
    inicializamos el numero de tokens
    */
    constructor() public {
        owner = msg.sender;
        token = new ERC20Basic(1000);
    }
}
