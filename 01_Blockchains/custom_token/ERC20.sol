// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <=0.8.9;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

//Interface de nuestro token ERC20
interface IERC20{
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
    
}

contract ERC20Basic is IERC20{
    
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