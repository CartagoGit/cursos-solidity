pragma solidity >0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney{
    // Instancia al contrato token
    ERC20Basic private token;
    
    // Direccion de Disney (owner)
    address payable public owner;
    
    // Constructor
    constructor () public {
        token = new ERC20Basic(10000);
        owner = msg.sender;
    }
    
    // Estructura de datos para almacenar a nuestros clientes de Disney
    struct cliente {
        uint tokens_comprados;
        string [] atracciones_disfrutadas;
    }
    
    // Mapping para el registro de clientes
    mapping (address=> cliente) public Clientes;
    
    
}