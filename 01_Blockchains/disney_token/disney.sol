pragma solidity >0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney{
    
    //----------------------------------------------- DECLARACIONES INICIALES ------------------------------------
    // Instancia al contrato token
    ERC20Basic private token;
    
    // Direccion de Disney (owner)
    address public owner;
    
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
        Clientes[msg.sender].tokens_comprados += _numTokens;
        
    }
    
    // Para detectar el numero de tokens disponibles en el contrato 
    function balanceOf() public view returns (uint){
        return token.balanceOf(address(this));
    }
    
    // Visualizar el numero de tokens restantes de un Clientes
    function MisTokens() public view returns (uint){
        return token.balanceOf(msg.sender);
    }
    
    // Generar mas tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }
    
    // Modificador para controlar las funciones ejecutables unicamente por nosotros (disney) y no por los usuarios
    modifier Unicamente(address _direccion){
        require(_direccion == owner, "No tienes permisos para ejecutar esta funcion.");
        _;
    }
    
    //----------------------------------------------- GESTION DE DISNEY ------------------------------------
    
    // Eventos
    event disfruta_atraccion(string, uint, address);
    event nueva_atraccion(string, uint);
    event baja_atraccion(string);
    
    // Estructura de datos de la atraccion
    struct atraccion {
        string nombre_atraccion;
        uint precio_atraccion;
        bool estado_atraccion;
    }
    
    // Mapping para relacionar un nombre de una atraccion con una estructura de datos de la atraccion
    mapping (string => atraccion) public MappingAtracciones;
    
    // Array para alamacenar el nombre de las atracciones
    string [] Atracciones;
    
    // Mapping para relacionar una ideantidad (cliente) con su historial en DISNEY
    mapping (address => string[]) HistorialAtracciones;
    
    //Funcion para crear una nueva atraccion (SOLO ES EJECUTABLE POR DISNEY)
    function NuevaAtraccion(string  memory _nombreAtraccion, uint _precio) public Unicamente(msg.sender){
        // Creacion de una atraccion
        MappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion, _precio, true);
        
        // almacenar en una array el nombre de la atraccion
        Atracciones.push(_nombreAtraccion);
        
        // Emision de evento para la nueva Atraccion
        emit nueva_atraccion(_nombreAtraccion, _precio);
    }
    
    //Funcion para dar de baja a las Atracciones SOLO DISNEY
    function BajaAtraccion (string memory _nombreAtraccion) public Unicamente(msg.sender){
        //Comprobar si la atraccion existe o no 
        //require(MappingAtracciones[_nombreAtraccion].estado_atraccion, "La atraccion no existe o ya esta dada de baja");
        
        // El estado de la atraccion pasa a FALSE -> no esta en uso 
        MappingAtracciones[_nombreAtraccion].estado_atraccion = false;
        
        //Emitimos el evento de baja_atraccion
        emit baja_atraccion(_nombreAtraccion);
        
    }
    
    //Funcion para visualizar las Atracciones
    function AtraccionesDisponibles()public view returns (string [] memory){
        return Atracciones;
    }
    
    // Funcion para subirse a una atraccion de disney y pagar en tokens
    function SubirseAtraccion(string memory _nombreAtraccion) public {
        //Precio de la atraccion en token 
        uint tokens_atraccion = MappingAtracciones[_nombreAtraccion].precio_atraccion;
        
        // Verifica el estado de la atraccion (si esta disponible para subirse)
        require(MappingAtracciones[_nombreAtraccion].estado_atraccion == true, "La atracción no esta disponible en estos momentos");
        
        //Verificar si el cliente tiene tokens suficientes para subirse a la atraccion
        require(tokens_atraccion <= MisTokens(), "No tienes suficientes tokens para poder acceder a la atracción.");
        
        /* El cliente paga la atracción en Tokens:
        - Ha sido necesario crear una funcion ERC20.sol con el nombre de: transferUser()
        debido a que en caso de usasr el Trnasder o TransderFrom las direcciones que se escogen
        para realizar la transaccion eran equivocadas. Ya que el msg.sender que recibian dichos metodos
        era la direccion del contrato y no la del usuario. */
        
        token.transferUser(msg.sender, address(this), tokens_atraccion);
        
        //Almacenamiento en el historial de Atracciones del cliente
        HistorialAtracciones[msg.sender].push(_nombreAtraccion);
        
        //evento de disfrutar de la atraccion
        emit disfruta_atraccion (_nombreAtraccion,tokens_atraccion, msg.sender);
        
    }
    
    //Visualiza el historial del cliente en las atracciones
    function HistorialAtraccionesCliente () public view returns (string [] memory){
        return HistorialAtracciones[msg.sender];
    }
    
    //Para devolver los tokens y recibir sus etherum
    function DevolverTokens (uint _numTokens) public payable {
        // El numero de tokens que se intenta devolver tiene que ser positivo
        require (_numTokens>0, "Necesitas devolver una cantidad positiva de tokens");
        
        // El usuario tiene que tener la misma o mayor cantidad de tokens que los que intenta devolver
        require (_numTokens <= MisTokens(), "No puedes devolver mas tokens de los que dispones");
        
        // El cliente devuelve los tokens
        token.transferUser(msg.sender, address(this), _numTokens);
        
        //Disney devuelve los ethers al cliente
        msg.sender.transfer(PrecioTokens(_numTokens));
    }
    
}