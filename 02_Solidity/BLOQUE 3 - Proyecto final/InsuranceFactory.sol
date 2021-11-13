// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.8.9;
import "./OperacionesBasicas.sol";
import "./ERC20.Sol";
import "./IHR_and_Labs.sol";

//------------------------------ Contrato para la compañia de seguros
contract InsuranceFactory is OperacionesBasicas {
    constructor() {
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
        uint256 precioTokensServicio;
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
    string[] private NombreServicios;
    address[] DireccionesLaboratorios;

    //Modificadores y restricciones sobre asegurados y aseguradoras
    function FuncionUnicamenteAsegurados(address _direccionAsegurado)
        public
        view
    {
        require(
            MappingAsegurados[_direccionAsegurado].AutorizacionCliente,
            "Direccion de asegurado NO autorizada"
        );
    }

    modifier OnlyAsegurados(address _direccionAsegurado) {
        FuncionUnicamenteAsegurados(_direccionAsegurado);
        _;
    }

    modifier OnlyAseguradora(address _direccionAseguradora) {
        require(
            Aseguradora == _direccionAseguradora,
            "Direccion de Aseguradora NO Autorizada"
        );
        _;
    }

    modifier OnlyAsegurado_o_Aseguradora(
        address _direccionAsegurado,
        address _direccionEntrante
    ) {
        require(
            (MappingAsegurados[_direccionEntrante].AutorizacionCliente &&
                _direccionAsegurado == _direccionEntrante) ||
                Aseguradora == _direccionEntrante,
            "Solamente la aseguradora o los asegurados autorizados"
        );
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
        address direccionAsegurado = address(
            new InsuranceHealthRecord(msg.sender, token, Insurance, Aseguradora)
        );
        MappingAsegurados[msg.sender] = cliente(
            msg.sender,
            true,
            direccionAsegurado
        );
        emit EventoAseguradoCreado(msg.sender, direccionAsegurado);
    }

    function visualizarAsegurados()
        public
        view
        OnlyAseguradora(msg.sender)
        returns (address[] memory)
    {
        return DireccionesAsegurados;
    }

    function consultarHistorialAsegurado(
        address _direccionAsegurado,
        address _direccionConsultor
    )
        public
        view
        OnlyAsegurado_o_Aseguradora(_direccionAsegurado, _direccionConsultor)
        returns (string memory)
    {
        string memory historial = "";
        address direccionContratoAsegurado = MappingAsegurados[
            _direccionAsegurado
        ].DireccionContrato;

        for (uint256 i = 0; i < NombreServicios.length; i++) {
            if (
                MappingServicios[NombreServicios[i]].EstadoServicio &&
                InsuranceHealthRecord(direccionContratoAsegurado)
                    .ServicioEstadoAsegurado(NombreServicios[i])
            ) {
                (
                    string memory nombreServicio,
                    uint256 precioServicio
                ) = InsuranceHealthRecord(direccionContratoAsegurado)
                        .HistorialAsegurado(NombreServicios[i]);
                historial = string(
                    abi.encodePacked(
                        historial,
                        "(",
                        nombreServicio,
                        ", ",
                        uint2str(precioServicio),
                        ") --- "
                    )
                );
            }
        }
        return historial;
    }

    function darBajaCliente(address _direccionAsegurado)
        public
        OnlyAseguradora(msg.sender)
    {
        MappingAsegurados[_direccionAsegurado].AutorizacionCliente = false;
        InsuranceHealthRecord(
            MappingAsegurados[_direccionAsegurado].DireccionContrato
        ).darBaja;
        emit EventoBajaAsegurado(_direccionAsegurado);
    }

    //SERVICIOS --------------------------------
    function nuevoServicio(
        string memory _nombreServicio,
        uint256 _precioServicio
    ) public OnlyAseguradora(msg.sender) {
        MappingServicios[_nombreServicio] = servicio(
            _nombreServicio,
            _precioServicio,
            true
        );
        NombreServicios.push(_nombreServicio);
        emit EventoServicioCreado(_nombreServicio, _precioServicio);
    }

    function darBajaServicio(string memory _nombreServicio)
        public
        OnlyAseguradora(msg.sender)
    {
        require(
            ServicioEstado(_nombreServicio),
            "No se ha dado de alta el servicio"
        );
        MappingServicios[_nombreServicio].EstadoServicio = false;
        emit EventoBajaServicio(_nombreServicio);
    }

    function ServicioEstado(string memory _nombreServicio)
        public
        view
        returns (bool)
    {
        return MappingServicios[_nombreServicio].EstadoServicio;
    }

    function getPrecioServicio(string memory _nombreServicio)
        public
        view
        returns (uint256 tokens)
    {
        require(
            ServicioEstado(_nombreServicio),
            "El servicio no esta disponible"
        );
        return MappingServicios[_nombreServicio].precioTokensServicio;
    }

    function ConsultarServiciosActivos() public view returns (string[] memory) {
        string[] memory ServiciosActivos = new string[](NombreServicios.length);
        uint256 contador = 0;
        for (uint256 i = 0; i < NombreServicios.length; i++) {
            if (ServicioEstado(NombreServicios[i])) {
                ServiciosActivos[contador] = NombreServicios[i];
                contador++;
            }
        }
        return ServiciosActivos;
    }

    //COMPRA DE TOKENS ----------------------------------
    function compraTokens(address _asegurado, uint256 _numTokens)
        public
        payable
        OnlyAsegurados(_asegurado)
    {
        uint256 Balance = balanceOf();
        require(
            _numTokens <= Balance,
            "No hay tantos tokens para comprar, compra un numero inferior"
        );
        require(_numTokens > 0, "Compra un numero positivo de tokens");

        token.transfer(msg.sender, _numTokens);
        emit EventoComprado(_numTokens);
    }

    function balanceOf() public view returns (uint256 tokens) {
        return (token.balanceOf(Insurance));
    }

    function generaTokens(uint256 _numTokens)
        public
        OnlyAseguradora(msg.sender)
    {
        token.increaseTotalSupply(_numTokens);
    }

    //LABORATORIO ----------------------------------
    function creacionLab() public {
        DireccionesLaboratorios.push(msg.sender);
        address direccionLab = address(new Laboratorio(msg.sender, Insurance));
        lab memory laboratorio = lab(direccionLab, true);
        MappingLab[msg.sender] = laboratorio;
        emit EventoLaboratorioCreado(msg.sender, direccionLab);
    }

    function visualizarLaboratorios()
        public
        view
        OnlyAseguradora(msg.sender)
        returns (address[] memory)
    {
        return DireccionesLaboratorios;
    }
}
