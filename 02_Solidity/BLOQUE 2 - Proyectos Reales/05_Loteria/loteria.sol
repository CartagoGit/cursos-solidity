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
        emit eventTokenComprado(_numTokens, msd.sender);
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
    function getTokenPerson () public view returns(uint){
        return token.balanceOf(msg.sender);
    }
    
    // ------------------------------------ TOKEN ---------------------------------
}

