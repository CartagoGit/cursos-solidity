pragma solidity >=0.4.0 <0.8.9;

contract Banco {
    //Definimos el tipo de dato complejo cliente
    struct cliente {
        string _nombre;
        address direccion;
        uint256 dinero;
    }

    //mapping para relacionar el nombre del cliente con el tipo de dato cliente
    mapping(string => cliente) Clientes;

    //Funcion para dar de alta a un nuevo Clientes
    function nuevoCliente(string memory _nombre) public {
        Clientes[_nombre] = cliente(_nombre, msg.sender, 0);
    }
}

contract Cliente is Banco {
    function altaCliente(string memory _nombre) public {
        nuevoCliente(_nombre);
    }

    function ingresarDinero(string memory _nombre, uint256 _cantidad) public {
        Clientes[_nombre].dinero = _cantidad;
    }

    function retirarDinero(string memory _nombre, uint256 _cantidad)
        public
        returns (bool)
    {
        bool flag = true;

        if (Clientes[_nombre].dinero > _cantidad) {
            Clientes[_nombre].dinero -= _cantidad;
            return flag;
        } else return !flag;
    }

    function consultarDinero(string memory _nombre)
        public
        view
        returns (uint256)
    {
        return Clientes[_nombre].dinero;
    }
}
