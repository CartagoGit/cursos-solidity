pragma solidity >=0.4.4 <0.8.9;

contract Estructuras {
    //Cliente de una pagina web de pago
    struct cliente {
        uint256 id;
        string name;
        string dni;
        string mail;
        uint256 phone_number;
        uint256 credit_number;
        uint256 secret_number;
    }

    cliente pepe =
        cliente(1, "Pepe", "123213213h", "pepe@gmail.com", 666666666, 1234, 11);

    // Amazon (cualquier pagina de compraventa)
    struct producto {
        string nombre;
        uint256 precio;
    }
    producto movil = producto("samsung", 300);

    //Proyecto ONG
    struct ONG {
        address ong;
        string nombre;
    }

    ONG caritas = ONG(0x5A8B9d31985a7246827F873426c2ef635924C0e5, "caritas");
}
