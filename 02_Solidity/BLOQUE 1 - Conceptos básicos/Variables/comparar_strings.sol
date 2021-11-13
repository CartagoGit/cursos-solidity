pragma solidity >=0.4.4 <0.8.9;

contract comparar {
    // Con estas funciones podriamos comparar strings haciendolo más eficiente para gastar menos gas.
    function compareStrings(string memory a, string memory b)
        public
        pure
        returns (bool)
    {
        return compareMemory(bytes(a), bytes(b));
    }

    function compareMemory(bytes memory a, bytes memory b)
        internal
        pure
        returns (bool)
    {
        return (a.length == b.length) && (keccak256(a) == keccak256(b));
    }
}
