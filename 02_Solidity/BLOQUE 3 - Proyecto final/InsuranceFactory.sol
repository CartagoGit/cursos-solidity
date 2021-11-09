// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.0 <0.8.9;
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
    address public Insurance;
    address payable public Aseguradora;
    
    //Mapeos y Arrays para clientes, servicios y laboratorios
    mapping(address => cliente) public MappingAsegurados;
    mapping(string => servicio) public MappingServicios;
    mapping(address => lab) public MappingLab;
    
    address[] DireccionesAsegurados;
    string [] private NombreServicios;
    address [] DireccionesLaboratorios;
    
    //Modificadores y restricciones sobre asegurados y aseguradoras
    function FuncionUnicamenteAsegurados(address _direccionAsegurado) private view{
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
    
    // CLIENTE --------------------------------
    function creacionContratoAsegurado() public {
        DireccionesAsegurados.push(msg.sender);
        address direccionAsegurado = address(new InsuranceHealthRecord(msg.sender, token, Insurance, Aseguradora));
        MappingAsegurados[msg.sender] = cliente(msg.sender, true, direccionAsegurado);
        emit EventoAseguradoCreado(msg.sender, direccionAsegurado);
    }
    
    function visualizarAsegurados() public view OnlyAseguradora(msg.sender) returns (address [] memory){
        return DireccionesAsegurados;
    }
    
    function consultarHistorialAsegurado(address _direccionAsegurado, address _direccionConsultor) public view OnlyAsegurado_o_Aseguradora(_direccionAsegurado, _direccionConsultor) returns (string memory){
        string memory historial = "";
        address direccionContratoAsegurado = MappingAsegurados[_direccionAsegurado].DireccionContrato;
        
        for (uint i=0; i< NombreServicios.length; i++){
            if(MappingServicios[NombreServicios[i]].EstadoServicio &&
                InsuranceHealthRecord(direccionContratoAsegurado).ServicioEstadoAsegurado(NombreServicios[i])
                ){
                    (string memory nombreServicio, uint precioServicio) = InsuranceHealthRecord(direccionContratoAsegurado).HistorialAsegurado(NombreServicios[i]);
                    historial = string(abi.encodePacked(historial, "(", nombreServicio, ", ", uint2str(precioServicio), ") --- "));
                }
        }
        return historial;
    }
    
    function darBajaCliente(address _direccionAsegurado) public OnlyAseguradora(msg.sender){
        MappingAsegurados[_direccionAsegurado].AutorizacionCliente = false;
        InsuranceHealthRecord(MappingAsegurados[_direccionAsegurado].DireccionContrato).darBaja;
        emit EventoBajaAsegurado(_direccionAsegurado);
    }
    
    //SERVICIOS --------------------------------
    function nuevoServicio(string memory _nombreServicio, uint256 _precioServicio) public OnlyAseguradora(msg.sender){
        MappingServicios[_nombreServicio] = servicio(_nombreServicio, _precioServicio, true);
        NombreServicios.push(_nombreServicio);
        emit EventoServicioCreado(_nombreServicio,_precioServicio);
    }
    
    function darBajaServicio(string memory _nombreServicio) public OnlyAseguradora(msg.sender){
        require(ServicioEstado(_nombreServicio), "No se ha dado de alta el servicio");
        MappingServicios[_nombreServicio].EstadoServicio = false;
        emit EventoBajaServicio(_nombreServicio);
    }
    
    function ServicioEstado(string memory _nombreServicio) public view returns (bool){
        return MappingServicios[_nombreServicio].EstadoServicio;
    }
    
    function getPrecioServicio(string memory _nombreServicio) public view returns(uint256 tokens){
        require(ServicioEstado(_nombreServicio), "El servicio no esta disponible");
        return MappingServicios[_nombreServicio].precioTokensServicio;
    }
    
    function ConsultarServiciosActivos() public view returns (string[] memory){
        string [] memory ServiciosActivos = new string [](NombreServicios.length);
        uint contador = 0;
        for (uint i=0; i<NombreServicios.length; i++){
            if(ServicioEstado(NombreServicios[i])) {
                ServiciosActivos[contador] = NombreServicios[i];
                contador ++;
            }
        }
        return ServiciosActivos;
        
    }
    
    //COMPRA DE TOKENS ----------------------------------
    function compraTokens(address _asegurado, uint _numTokens) public payable OnlyAsegurados(_asegurado){
        uint256 Balance = balanceOf();
        require(_numTokens<=Balance, "No hay tantos tokens para comprar, compra un numero inferior");
        require(_numTokens>0,"Compra un numero positivo de tokens");
        
        token.transfer(msg.sender, _numTokens);
        emit EventoComprado(_numTokens);
    }
    
    function balanceOf() public view returns (uint256 tokens){
        return (token.balanceOf(Insurance));
    }
    
    function generaTokens(uint _numTokens) public OnlyAseguradora(msg.sender){
        token.increaseTotalSupply(_numTokens);
    }
    
    //LABORATORIO ----------------------------------
    function creacionLab() public{
        DireccionesLaboratorios.push(msg.sender);
        address direccionLab = address(new Laboratorio(msg.sender,Insurance));
        lab memory laboratorio = lab(direccionLab, true);
        MappingLab[msg.sender] = laboratorio;
        emit EventoLaboratorioCreado(msg.sender,direccionLab);
    }
    
    function visualizarLaboratorios() public view OnlyAseguradora(msg.sender) returns (address [] memory){
        return DireccionesLaboratorios;
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
    
    Owner public propietario;
    //InsuranceFactory public insurance = InsuranceFactory(propietario.insurance);
    
    
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
    //ServiciosSolicitados[] ArrayHistorialServiciosSolicitados;
  
    event EventoSelfDestruct(address);
    event EventoDevolverTokens(address, uint256);
    event EventoServicioPagado(address, string, uint256);
    event EventoPeticionServicioLab(address, address, string);
    
    modifier OnlyOwner(address _direccion){
        require(_direccion == propietario.direccionPropietario, "No eres el asegurado de la poliza");
        _;
    }
    
    function HistorialAseguradoLaboratorio() public view returns (ServiciosSolicitadosLab[] memory){
        return ArrayHistorialAseguradoLab;
    }
    
    function HistorialAsegurado(string memory _servicio) public view returns(string memory nombreServicio, uint precioServicio){
        return (MappingHistorialAsegurado[_servicio].nombreServicio, MappingHistorialAsegurado[_servicio].precioServicio);
    }
    
    function ServicioEstadoAsegurado(string memory _servicio) public view returns(bool){
        return MappingHistorialAsegurado[_servicio].estadoServicio;
    }
    
    function darBaja() public OnlyOwner(msg.sender){
        emit EventoSelfDestruct(msg.sender);
        selfdestruct(payable(msg.sender));
    }
    
    function CompraTokens (uint _numTokens) payable public OnlyOwner(msg.sender){
        require(_numTokens>0, "Necesitas comprar un numero positivo de tokens.");
        uint coste = calcularPrecioTokens(_numTokens);
        require(msg.value >= coste, "Se necesitan mas ethers para realizar la compra");
        uint returnValue = msg.value - coste;
        payable(msg.sender).transfer(returnValue);
        InsuranceFactory(propietario.insurance).compraTokens(msg.sender, _numTokens);
    }
    
    function balanceOf() public view OnlyOwner(msg.sender) returns (uint256 _blance){
        return (propietario.tokens.balanceOf(address(this)));
    }
    
    function devolverTokens(uint _numTokens) public payable OnlyOwner(msg.sender){
        require(_numTokens>0, "Necesitas devolver un numero positivo de tokens");
        require(_numTokens<=balanceOf(), "No tienes los tokens que deseas devolver");
        propietario.tokens.transfer(propietario.aseguradora, _numTokens);
        payable(msg.sender).transfer(calcularPrecioTokens(_numTokens));
        emit EventoDevolverTokens(msg.sender, _numTokens);
    }
    
    function peticionServicio(string memory _servicio) public OnlyOwner(msg.sender){
        require(InsuranceFactory(propietario.insurance).ServicioEstado(_servicio), "El servicio no esta activo en la aseguradora");
        uint256 pagoTokens = InsuranceFactory(propietario.insurance).getPrecioServicio(_servicio);
        require(pagoTokens<=balanceOf(), "Necesitas comprar mas tokens para optar a este servicio");
        propietario.tokens.transfer(propietario.aseguradora, pagoTokens);
        MappingHistorialAsegurado[_servicio] = ServiciosSolicitados(_servicio, pagoTokens, true);
        emit EventoServicioPagado(msg.sender, _servicio, pagoTokens);
    }
    
    function peticionServicioLab(address _direccionLab, string memory _servicio) public payable OnlyOwner(msg.sender){
        Laboratorio contratoLab = Laboratorio(_direccionLab);
        require (msg.value == contratoLab.ConsultarPrecioServicios(_servicio)* 1 ether, "Operacion invalida");
        contratoLab.DarServicio(msg.sender, _servicio);
        payable(contratoLab.addressLab()).transfer(contratoLab.ConsultarPrecioServicios(_servicio)*1 ether);
        ArrayHistorialAseguradoLab.push(ServiciosSolicitadosLab(_servicio, contratoLab.ConsultarPrecioServicios(_servicio), _direccionLab));
        emit EventoPeticionServicioLab(_direccionLab, msg.sender, _servicio);
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
    
    //TODO:
    function ConsultarPrecioServicios(string memory _servicio) public view returns (uint){
        return 0;
    }
    //TODO:
    function DarServicio(address _direccionAsegurado, string memory _servicio) public {
        
    } 
}