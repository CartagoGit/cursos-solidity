// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.0 <=8.9.0;

import "./ERC20.sol";


contract loteria {
    ERC20Basic private token;
    
    // Direcciones
    address public owner;
    address public contrato;
    
    // Numero de tokens a crear
    uint tokens_creados = 10000000;
    
    //Eventos
    event eventTokenComprado (uint, address);
    
    //constructor
    constructor (){
        token = new ERC20Basic(tokens_creados);
        owner = msg.sender;
        contrato = address(this);
    }
    
    // ------------------------------------ TOKEN ---------------------------------
    
    //Establecer el precio de los tokens en ethers
    function precioTokens(uint _numTokens) internal pure returns (uint){
        return _numTokens*(1 ether);
    }
    
    //Generar mas tokens por la loteria
    function generaTokens(uint _numTokens) public onlyOwner(){
        token.increaseTotalSupply(_numTokens);
    }
    
    //Modificador para acceso solo al owner del contrato
    modifier onlyOwner (){
        require(owner==msg.sender, "No tienes permisos para ejecutar esta funcion.");
        _;
    }
    
    // Funcion para comprar tokens
    function buyTokens(uint _numTokens) public payable {
        //Calcular el coste de los tokens
        uint coste = precioTokens(_numTokens);
        // Se requiere que el valor de ethers pagados sea equivalente al coste
        require (msg.value >= coste, "Compra menos Tokens o paga con mas Ethers");
        //calcular el cambio, la diferencia a devolver entre lo pagado y el coste
        uint returnValue = msg.value - coste;
        //Obtener el balance de Tokens del contrato
        uint balance = tokensDisponibles();
        //Filtro para evaluar los tokens a comprar con los tokens disponibles 
        require (_numTokens <= balance, "Compra un numero de Tokens adecuado");
        //transferencia de la diferencia
        payable(msg.sender).transfer(returnValue);
        // transferencia de tokens al comprador
        token.transfer(msg.sender, _numTokens);
        //evento al comprar token
        emit eventTokenComprado(_numTokens, msg.sender);
    }
    
    // Balance de tokens en el contrato
    function tokensDisponibles() public view returns(uint){
        return token.balanceOf(contrato);
    }
    
    //Obtener balance acumulado en el Bote
    function balanceBote() public view returns (uint){
        return token.balanceOf(owner);
    }
    
    // Ver los tokens que se disponen en el bolsillo
    function getTokensPerson () public view returns(uint){
        return token.balanceOf(msg.sender);
    }
    
    // ------------------------------------ LOTERIA ---------------------------------
    
    //Precio del boleto en Tokens
    uint public precioBoleto = 5;
    //relacion entre la persona que compra los boletos y los numeros de los boletos
    mapping (address => uint[]) map_idPersona_boletos;
    //Relacion nevesaria para identificar al ganador
    mapping (uint => address) map_ganador;
    //Numero aleatorio
    uint randNonce = 0;
    //Boletos generados
    uint [] boletos_comprados;
    //Eventos 
    event event_boleto_comprado(uint, address); //al comprar un boleto
    event event_boleto_ganador(uint); //evento del ganador
    
    //Funcion para comprar boletos
    function comprarBoleto(uint _boletos) public{
        //Precio total de los colegos a comprar
        uint precio_total_boletos = _boletos*precioBoleto;
        //Filtrado de los tokens a pagar
        require(precio_total_boletos<=getTokensPerson(), "No tienes tokens suficientes para comprar tanto boletos");
        //transferencia de tokens al owner -> bote/premio
        token.transferUser(msg.sender, owner, precio_total_boletos);
        
        /*
        Lo que esto haria es tomar la marca de tiempo now, el msg.sender y un nonce
        (un numero que solo se utiliza una vez, para que no ejecutemos dos veces la misma 
        funcion de hash con los mismos parametros de entrada) en incremento.
        Luego se utiliza el keccak256 para convertir estas entradas a un hash aleatorio,
        convertir ese has a un uint y luego utilizamos %10000 para tomar los ultimos 4 digitos.
        Dando un valor aleatorio entre 0-9999.
        */
        for (uint i; i< _boletos; i++){
            uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 10000;
            //Almacenamos los datos de los boletos
            map_idPersona_boletos[msg.sender].push(random);
            //numero de boleto comprado
            boletos_comprados.push(random);
            //adignacion del adn del boleto para tener un ganador
            map_ganador[random] = msg.sender;
            //Emision del evento
            emit event_boleto_comprado(random, msg.sender);
        }
    }
    
    // Visualizar el numero de boletos de una Persona
    function getBoletosPerson() public view returns (uint [] memory){
        return map_idPersona_boletos[msg.sender];
    }
    
    // Funcion para generar un ganador e ingresarle los tokens
    function generarGanador() public onlyOwner(){
        //Debe haber boletos comprados para generar un ganador
        require(boletos_comprados.length<0, "No hay boletos comprados"); 
        //declaracion de la longitud del array
        uint longitud = boletos_comprados.length;
        //aleatoriamente elijo un numero entre 0 - y el numero de boletos comprados
        uint posicion_array = uint (uint(keccak256(abi.encodePacked(block.timestamp)))%longitud);
        uint eleccion = boletos_comprados[posicion_array];
        
        //Emision del evento del ganador
        emit event_boleto_ganador(eleccion);
        //recuperar la direccion del ganador
        address direccion_ganador = map_ganador[eleccion];
        //Enviarle los tokens del premio al ganador
        token.transferUser(msg.sender, direccion_ganador, balanceBote());
    }
}

