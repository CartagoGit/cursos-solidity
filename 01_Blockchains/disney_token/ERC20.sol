// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <=0.8.9;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";


//---------------------------------------------------------------->
//Para añadir Ethers de test en la red RINKEBY 
//https://www.rinkeby.io/#faucet
//https://rinkeby.etherscan.io/
//<----------------------------------------------------------------


//Interface de nuestro token ERC20-----------------------------------

interface IERC20{
    
    //INTERFACE BASICAS-----------------------------------
    
    //Devuelve la cantidad de tokens en existencia
    function totalSupply() external view returns (uint256);

    //Devuelve la cantidad de tokens para una direccion indicada por parametros
    function balanceOf(address account) external view returns (uint256);

    //Devuelve el numero de tokens que el spender podra gastar en nombre del propietario (owner)
    function allowance(address owner, address spender) external view returns (uint256);
    
    //Devuelve un valor booleano resultado de la operacion indicada
    function transfer(address recipient, uint256 amount) external returns (bool);
    
    //Devuelve un valor booleano resultado de la operacion indicada entre un usuario y una compra
    function transferUser(address user,address recipient, uint256 amount) external returns (bool);

    //Devuelve valor booleano con el resultado de la operacion de gasto
    function approve(address spender, uint256 amount) external returns (bool);
    
    //Devuelve un valor booleano con el resultado de la operacion de paso de una cantidad de tokens usando el metodo allowance()
    function transferFrom(address spender, address recipient, uint256 amount) external returns (bool);
    
    //EVENTOS-----------------------------------
    
    //Evento que se de debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    //Evento que se debe emitir cuando se establece una asignacion con el metodo allowance()
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
}

//Contrato Creado -> 
//PARA HACER PRUEBAS CON VARIAS WALLETS
// Direccion inicial - Cartago-> 0xc43D4D85D321c24d4Ae11fEbc36C0fF7c353fc94
//Cuenta de pruebas -> 0x5A8B9d31985a7246827F873426c2ef635924C0e5
//
//Implementacion de las funciones del token ERC20
contract ERC20Basic is IERC20{
    
    //Cosntantes del contrato
    string public constant name = "CartagoToken_Curso01_Disney";
    //string public constant symbol = "CN-Curso-01";
    string public constant symbol = "CartagoTkn2";
    uint8 public constant decimals = 2;
    
    
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);
    
    using SafeMath for uint256;
    
    //Mapeo de la cantidad y los poseedores de los tokens
    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 totalSupply_;
    
    //El minuto 0, el momento donde se crea la moneda virtual, el constructor
    constructor (uint256 initialSupply) public{
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }
    
    //Para devolver la cantidad de tokens totales
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }
    
    //Incrementar la cantidad total con un numero de tokens // el minado
    function increaseTotalSupply(uint newTokensAmount) public {
        totalSupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }

    //Para saber la cantidad de tokens de un address
    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }

    //Saber cuantos tokens puede usar la persona delegada del propietario de los tokens
    function allowance(address owner, address delegate) public override view returns (uint256){
        return allowed[owner][delegate];
    }
    
    //Para transferir tokens de un adress a otro, usamos los metodos sub y add de la libreria que importamos
    function transfer(address recipient, uint256 numTokens) public override returns (bool){
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens); //es importante el orden del a transaccion, ya que si la transaccion se corta, es preferible a que falte a crear una inflaccion
        balances[recipient] = balances[recipient].add(numTokens);
        emit Transfer(msg.sender, recipient, numTokens);
        return true;
    }
    
    function transferUser(address user, address recipient, uint256 numTokens) public override returns (bool){
        require(numTokens <= balances[user]);
        balances[user] = balances[user].sub(numTokens); //es importante el orden del a transaccion, ya que si la transaccion se corta, es preferible a que falte a crear una inflaccion
        balances[recipient] = balances[recipient].add(numTokens);
        emit Transfer(msg.sender, recipient, numTokens);
        return true;
    }
    
    //Para permitir que otra direccion use cierta cantidad de tokens de otro address
    function approve(address delegate, uint256 numTokens) public override returns (bool){
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    
    //Para transferir tokens con un intermediario. NO es una transferencia directa entre el poseedor y el comprador. Nosotros seriamos el intermediario.
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool){
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer]=balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}