// Indicamos la version
pragma solidity >=0.4.4 <0.8.9;

contract funciones_globales{
    //Funcion msg.sender
    function MsgSender() public view returns(address){
        return msg.sender;
    }
    
    // function now, devuelve el timestamp en segundos siguiendo el tiempo actual en unix, es un alias para block.timestamp
    function Now() public view returns(uint){
        return now;
    }
    
    // Funcion block.coinbase, devuelve la direccion del minero
    function BlockCoinbase() public view returns(address){
        return block.coinbase;
    }
    
    // function block.difficulty
    function BlockDifficulty() public view returns(uint){
        return block.difficulty;
    }
    
    // function block.number, nos devuelve el numero del bloque actual
    function BlockNumber() public view returns (uint){
        return block.number;
    }
    
    // Funcion msg.sig, devuelve  bytes32
    function MsgSig() public view returns(bytes4){
        return msg.sig;
    }
    
    // funcion tx.gasprice, devuelve el precio del gasprice
    function txGasPrice() public view returns(uint){
        return tx.gasprice;
    }
    
}