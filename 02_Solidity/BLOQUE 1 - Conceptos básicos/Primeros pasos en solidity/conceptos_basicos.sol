pragma solidity >=0.4.0 <0.8.9;
import "./ERC20.sol";

contract PrimerContrato{
    
    address owner;
    ERC20Basic token;

    constructor() public {
        owner=msg.sender;
        token = new ERC20Basic(1000);
    }
}