//Funcion auxiliar que transforma un uint a un string

// Funcion para antes de 0.8.0
function uint2str(uint256 _i)
    internal
    pure
    returns (string memory _uintAsString)
{
    if (_i == 0) {
        return "0";
    }
    uint256 j = _i;
    uint256 len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint256 k = len - 1;
    while (_i != 0) {
        bstr[k--] = bytes1(uint8(48 + (_i % 10)));
        _i /= 10;
    }
    return string(bstr);
}

// Funcion uint2str adaptada para posterior a 0.8.0

function uint2str(uint256 _i)
    internal
    pure
    returns (string memory _uintAsString)
{
    if (_i == 0) {
        return "0";
    }
    uint256 j = _i;
    uint256 len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint256 k = len;
    while (_i != 0) {
        k = k - 1;
        uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
        bytes1 b1 = bytes1(temp);
        bstr[k] = b1;
        _i /= 10;
    }
    return string(bstr);
}
