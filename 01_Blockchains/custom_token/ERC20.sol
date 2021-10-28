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
}