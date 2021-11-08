// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 <0.8.9;
import "./OperacionesBasicas.sol";
import "./ERC20.Sol";

//Contrato para la compañia de seguros
contract InsuranceFactory is OperacionesBasicas{
    constructor () {
        token = new ERC20Basic(100);
        Insurance = address(this);
        Aseguradora = payable(msg.sender);
    }
    
    struct cliente {
        address DireccionCliente;
        bool AutorizacionCliente;
        address DireccionContrato;
    }
    
    struct servicio {
        string nombreServicio;
        uint precioTokensServicio;
        bool EstadoServicio;
    }
    
    struct lab {
        address direccionContratoLab;
        bool ValidacionLab;
    }
    
    //Instancia del contrato token
    ERC20Basic private token;
    
    //Declaracion de las direcciones
    address Insurance;
    address payable public Aseguradora;
    
    //Mapeos y Arrays para clientes, servicios y laboratorios
    mapping(address => cliente) public MappingAsegurados;
    mapping(string => servicio) public MappingServicios;
    mapping(address => lab) public MappingLab;
    
    address[] DireccionesAsegurados;
    string [] private nombreServicios;
    address [] direccionesLaboratios;
    
    //Modificadores y restricciones sobre asegurados y aseguradoras
    function FuncionUnicamenteAsegurados(address _direccionAsegurado) public view{
        require(MappingAsegurados[_direccionAsegurado].AutorizacionCliente, "Direccion de asegurado NO autorizada");
    }
    
    modifier OnlyAsegurados(address _direccionAsegurado){
        FuncionUnicamenteAsegurados(_direccionAsegurado);
        _;
    }
    
    modifier OnlyAseguradora(address _direccionAseguradora){
        require(Aseguradora==_direccionAseguradora, "Direccion de Aseguradora NO Autorizada");
        _;
    }
    
    modifier OnlyAsegurado_o_Aseguradora(address _direccionAsegurado, address _direccionEntrante){
        require( (MappingAsegurados[_direccionEntrante].AutorizacionCliente && _direccionAsegurado == _direccionEntrante) 
            || Aseguradora == _direccionEntrante, "Solamente la aseguradora o los asegurados autorizados");
        _;
    }
    
    // Eventos 
    event EventoComprado(uint256);
    event EventoServicioProporcionado(address, string, uint256);
    event EventoLaboratorioCreado(address, address);
    event EventoAseguradoCreado(address, address);
    event EventoBajaCliente(address);
    event EventoServicioCreado(string, uint256);
    event EventoBajaServicio(string);
    
    
    
}