pragma solidity >0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney{
    
    //----------------------------------------------- DECLARACIONES INICIALES ------------------------------------
    // Instancia al contrato token
    ERC20Basic private token;
    
    // Direccion de Disney (owner)
    address payable public owner;
    
    // Constructor
    constructor () public {
        token = new ERC20Basic(10000); //Numero de tokens que habra del token
        owner = msg.sender;
    }
    
    // Estructura de datos para almacenar a nuestros clientes de Disney
    struct cliente {
        uint tokens_comprados;
        string [] atracciones_disfrutadas;
    }
    
    // Mapping para el registro de clientes
    mapping (address=> cliente) public Clientes;
    
    //----------------------------------------------- GESTION DE TOKENS ------------------------------------
    
    // Funcion para establecer el precio de un token
    function PrecioTokens(uint _numTokens) internal pure returns (uint){
        //Conversion de Tokens a Ethers: Token -> 1 ether (Puede ser conversion a lo que queramos, el ejemplo es de 1:1)
        return _numTokens*(1 ether);
    }
    
    // Funcion para comprar Tokens en disney y disfrutar de las atracciones
    function CompraTokens(uint _numTokens) public payable{
        
        // Establecer el precio de los Tokens
        uint coste = PrecioTokens(_numTokens);
        
        // Se evalua el dinero que el cliente paga por los Tokens
        require (msg.value >= coste, "Compra menos Tokens o paga con mas ethers.");
        
        //Diferencia de lo que el cliente paga
        uint returnValue = msg.value - coste;
        
        // Disney retorna la cantidad de ethers que sobran al cliente
        msg.sender.transfer(returnValue);
        
        //Obtencion del numero de tokens disponibles y comprobar si se esta comprando una cifra inferior a la cantidad que hay
        uint Balance = balanceOf();
        require(_numTokens <= Balance, "Compra un número menor de tokens");
        
        // Se transfiere el numero de tokens al cliente
        token.transfer(msg.sender, _numTokens);
        
        // Registro de tokens tokens_comprados
        Clientes[msg.sender].tokens_comprados = _numTokens;
        
    }
    
    //Para detectar el numero de tokens disponibles en el contrato 
    function balanceOf() public view returns (uint){
        return token.balanceOf(address(this));
    }
    
}