// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <=0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

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

    //Devuelve valor booleano con el resultado de la operacion de gasto
    function approve(address spender, uint256 amount) external returns (bool);
    
    //Devuelve un valor booleano con el resultado de la operacion de paso de una cantidad de tokens usando el metodo allowance()
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    //EVENTOS-----------------------------------
    
    //Evento que se de debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    //Evento que se debe emitir cuando se establece una asignacion con el metodo allowance()
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
}


//Implementacion de las funciones del token ERC20
contract ERC20Basic is IERC20{
    
    //Cosntantes del contrato
    string public constant name = "CartagoToken";
    string public constant symbol = "Cart";
    uint8 public constant decimals = 18;
    
    
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
    
    function totalSupply() public override view returns (uint256){
        return 0;
    }

    function balanceOf(address account) public override view returns (uint256){
        return 0;
    }

    function allowance(address owner, address spender) public override view returns (uint256){
        return 0;
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool){
        return false;
    }
    
    function approve(address spender, uint256 amount) public override returns (bool){
        return false;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool){
        return false;
    }
}