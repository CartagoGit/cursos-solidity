pragma solidity >=0.4.4 <0.8.9;

contract Estructuras{
    
    //Cliente de una pagina web de pago
    struct cliente{
        uint id;
        string name;
        string dni;
        string mail;
        uint phone_number;
        uint credit_number;
        uint secret_number;
    }
    
    cliente pepe= cliente(1,"Pepe","123213213h", "pepe@gmail.com", 666666666, 1234, 11 );

    // Amazon (cualquier pagina de compraventa)
    struct producto{
        string nombre;
        uint precio;
    }
    producto movil =producto("samsung", 300);
    
    //Proyecto ONG
    struct ONG{
        address ong;
        string nombre;
        
    }
    
    ONG caritas = ONG(0x123214123,"caritas");
    
    
}