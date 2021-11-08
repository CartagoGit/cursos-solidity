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
    string [] private NombreServicios;
    address [] DireccionesLaboratorios;
    
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
    event EventoBajaAsegurado(address);
    event EventoServicioCreado(string, uint256);
    event EventoBajaServicio(string);
    
    //Funciones 
    function creacionLab() public{
        DireccionesLaboratorios.push(msg.sender);
        address direccionLab = address(new Laboratorio(msg.sender,Insurance));
        lab memory laboratorio = lab(direccionLab, true);
        MappingLab[msg.sender] = laboratorio;
        emit EventoLaboratorioCreado(msg.sender,direccionLab);
    }
    
    function creacionContratoAsegurado() public {
        DireccionesAsegurados.push(msg.sender);
        address direccionAsegurado = address(new InsuranceHealthRecord(msg.sender, token, Insurance, Aseguradora));
        MappingAsegurados[msg.sender] = cliente(msg.sender, true, direccionAsegurado);
        emit EventoAseguradoCreado(msg.sender, direccionAsegurado);
    }
    
    function visualizarLaboratorios() public view OnlyAseguradora(msg.sender) returns (address [] memory){
        return DireccionesLaboratorios;
    }
    
    function visualizarAsegurados() public view OnlyAseguradora(msg.sender) returns (address [] memory){
        return DireccionesAsegurados;
    }
}

//------------------------------ Contrato IHR del asegurado
contract InsuranceHealthRecord is OperacionesBasicas{
    constructor(address _asegurado, IERC20 _token, address _seguro, address _aseguradora){
        propietario.direccionPropietario = _asegurado;
        propietario.saldoPropietario = 0;
        propietario.estado = Estado.alta;
        propietario.tokens = _token;
        propietario.insurance = _seguro;
        propietario.aseguradora = payable(_aseguradora);
    }
    
    Owner propietario;
    
    struct Owner{
        address direccionPropietario;
        uint saldoPropietario;
        Estado estado;
        IERC20 tokens;
        address insurance;
        address payable aseguradora;
    }
    
    enum Estado{alta, baja}
    
    struct ServiciosSolicitados{
        string nombreServicio;
        uint256 precioServicio;
        bool estadoServicio;
    }
    
    struct ServiciosSolicitadosLab{
        string nombreServicio;
        uint256 precioServicio;
        address direccionLab;
    }
    
    mapping (string => ServiciosSolicitados) MappingHistorialAsegurado;
    ServiciosSolicitadosLab[] ArrayHistorialAseguradoLab;
    ServiciosSolicitados[] ArrayHistorialServiciosSolicitados;
    
    function HistorialAseguradoLaboratorio() public view returns (ServiciosSolicitadosLab[] memory){
        return ArrayHistorialAseguradoLab;
    }
    
}

//---------------------------------- Contrato del Laboratorio
contract Laboratorio is OperacionesBasicas{
    constructor(address _addressLab, address _contractAseguradora){
        addressLab = _addressLab;
        contractAseguradora = _contractAseguradora;
        contractLab = address(this);
    }
    
    address public addressLab;
    address contractAseguradora;
    address contractLab;
}