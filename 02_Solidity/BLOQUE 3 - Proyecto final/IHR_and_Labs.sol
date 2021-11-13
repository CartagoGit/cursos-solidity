// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.8.9;
import "./OperacionesBasicas.sol";
import "./ERC20.Sol";
import "./InsuranceFactory.sol";

//------------------------------ Contrato IHR del asegurado
contract InsuranceHealthRecord is OperacionesBasicas {
    constructor(
        address _asegurado,
        IERC20 _token,
        address _seguro,
        address _aseguradora
    ) {
        propietario.direccionPropietario = _asegurado;
        propietario.saldoPropietario = 0;
        propietario.estado = Estado.alta;
        propietario.tokens = _token;
        propietario.insurance = _seguro;
        propietario.aseguradora = payable(_aseguradora);
    }

    Owner public propietario;
    //InsuranceFactory public insurance = InsuranceFactory(propietario.insurance);

    struct Owner {
        address direccionPropietario;
        uint256 saldoPropietario;
        Estado estado;
        IERC20 tokens;
        address insurance;
        address payable aseguradora;
    }

    enum Estado {
        alta,
        baja
    }

    struct ServiciosSolicitados {
        string nombreServicio;
        uint256 precioServicio;
        bool estadoServicio;
    }

    struct ServiciosSolicitadosLab {
        string nombreServicio;
        uint256 precioServicio;
        address direccionLab;
    }

    mapping(string => ServiciosSolicitados) MappingHistorialAsegurado;
    ServiciosSolicitadosLab[] ArrayHistorialAseguradoLab;
    //ServiciosSolicitados[] ArrayHistorialServiciosSolicitados;

    event EventoSelfDestruct(address);
    event EventoDevolverTokens(address, uint256);
    event EventoServicioPagado(address, string, uint256);
    event EventoPeticionServicioLab(address, address, string);

    modifier OnlyOwner(address _direccion) {
        require(
            _direccion == propietario.direccionPropietario,
            "No eres el asegurado de la poliza"
        );
        _;
    }

    function HistorialAseguradoLaboratorio()
        public
        view
        returns (ServiciosSolicitadosLab[] memory)
    {
        return ArrayHistorialAseguradoLab;
    }

    function HistorialAsegurado(string memory _servicio)
        public
        view
        returns (string memory nombreServicio, uint256 precioServicio)
    {
        return (
            MappingHistorialAsegurado[_servicio].nombreServicio,
            MappingHistorialAsegurado[_servicio].precioServicio
        );
    }

    function ServicioEstadoAsegurado(string memory _servicio)
        public
        view
        returns (bool)
    {
        return MappingHistorialAsegurado[_servicio].estadoServicio;
    }

    function darBaja() public OnlyOwner(msg.sender) {
        emit EventoSelfDestruct(msg.sender);
        selfdestruct(payable(msg.sender));
    }

    function CompraTokens(uint256 _numTokens)
        public
        payable
        OnlyOwner(msg.sender)
    {
        require(
            _numTokens > 0,
            "Necesitas comprar un numero positivo de tokens."
        );
        uint256 coste = calcularPrecioTokens(_numTokens);
        require(
            msg.value >= coste,
            "Se necesitan mas ethers para realizar la compra"
        );
        uint256 returnValue = msg.value - coste;
        payable(msg.sender).transfer(returnValue);
        InsuranceFactory(propietario.insurance).compraTokens(
            msg.sender,
            _numTokens
        );
    }

    function balanceOf()
        public
        view
        OnlyOwner(msg.sender)
        returns (uint256 _blance)
    {
        return (propietario.tokens.balanceOf(address(this)));
    }

    function devolverTokens(uint256 _numTokens)
        public
        payable
        OnlyOwner(msg.sender)
    {
        require(
            _numTokens > 0,
            "Necesitas devolver un numero positivo de tokens"
        );
        require(
            _numTokens <= balanceOf(),
            "No tienes los tokens que deseas devolver"
        );
        propietario.tokens.transfer(propietario.aseguradora, _numTokens);
        payable(msg.sender).transfer(calcularPrecioTokens(_numTokens));
        emit EventoDevolverTokens(msg.sender, _numTokens);
    }

    function peticionServicio(string memory _servicio)
        public
        OnlyOwner(msg.sender)
    {
        require(
            InsuranceFactory(propietario.insurance).ServicioEstado(_servicio),
            "El servicio no esta activo en la aseguradora"
        );
        uint256 pagoTokens = InsuranceFactory(propietario.insurance)
            .getPrecioServicio(_servicio);
        require(
            pagoTokens <= balanceOf(),
            "Necesitas comprar mas tokens para optar a este servicio"
        );
        propietario.tokens.transfer(propietario.aseguradora, pagoTokens);
        MappingHistorialAsegurado[_servicio] = ServiciosSolicitados(
            _servicio,
            pagoTokens,
            true
        );
        emit EventoServicioPagado(msg.sender, _servicio, pagoTokens);
    }

    function peticionServicioLab(address _direccionLab, string memory _servicio)
        public
        payable
        OnlyOwner(msg.sender)
    {
        Laboratorio contratoLab = Laboratorio(_direccionLab);
        require(
            msg.value ==
                contratoLab.ConsultarPrecioServicios(_servicio) * 1 ether,
            "Operacion invalida"
        );
        contratoLab.DarServicio(msg.sender, _servicio);
        payable(contratoLab.addressLab()).transfer(
            contratoLab.ConsultarPrecioServicios(_servicio) * 1 ether
        );
        ArrayHistorialAseguradoLab.push(
            ServiciosSolicitadosLab(
                _servicio,
                contratoLab.ConsultarPrecioServicios(_servicio),
                _direccionLab
            )
        );
        emit EventoPeticionServicioLab(_direccionLab, msg.sender, _servicio);
    }
}

//---------------------------------- Contrato del Laboratorio
contract Laboratorio is OperacionesBasicas {
    constructor(address _addressLab, address _contractAseguradora) {
        addressLab = _addressLab;
        contractAseguradora = _contractAseguradora;
        contractLab = address(this);
    }

    struct ResultadoServicio {
        string diagnostico_servicio;
        string codigo_IPFS;
    }

    struct ServiciosLab {
        string nombreServicio;
        uint256 precio;
        bool enFuncionamiento;
    }

    mapping(address => string) public MappingServiciosSolicitados;
    mapping(address => ResultadoServicio) MappingResultadosServiciosLab;
    mapping(string => ServiciosLab) public MappingServiciosLab;
    address[] public arr_peticionesServicios;
    string[] arr_nombreServiciosLab;

    address public addressLab;
    address contractAseguradora;
    address contractLab;

    event EventoServicioFuncionando(string, uint256);
    event EventoDarServicio(address, string);

    modifier OnlyLab(address _direccion) {
        require(
            _direccion == addressLab,
            "Solo el laboratorio asignado puede ejecutar esta funcion"
        );
        _;
    }

    function NuevoServicioLab(string memory _servicio, uint256 _precio)
        public
        OnlyLab(msg.sender)
    {
        MappingServiciosLab[_servicio] = ServiciosLab(_servicio, _precio, true);
        arr_nombreServiciosLab.push(_servicio);
        emit EventoServicioFuncionando(_servicio, _precio);
    }

    function consultarServicios() public view returns (string[] memory) {
        return arr_nombreServiciosLab;
    }

    function ConsultarPrecioServicios(string memory _servicio)
        public
        view
        returns (uint256)
    {
        return MappingServiciosLab[_servicio].precio;
    }

    function DarServicio(address _direccionAsegurado, string memory _servicio)
        public
    {
        InsuranceFactory IF = InsuranceFactory(contractAseguradora);
        IF.FuncionUnicamenteAsegurados(_direccionAsegurado);
        require(
            MappingServiciosLab[_servicio].enFuncionamiento,
            "El servicio no esta en funcionamiento"
        );
        MappingServiciosSolicitados[_direccionAsegurado] = _servicio;
        arr_peticionesServicios.push(_direccionAsegurado);
        emit EventoDarServicio(_direccionAsegurado, _servicio);
    }

    function DarResultados(
        address _direccionAsegurado,
        string memory _diagnostico,
        string memory _codigoIPFS
    ) public OnlyLab(msg.sender) {
        MappingResultadosServiciosLab[_direccionAsegurado] = ResultadoServicio(
            _diagnostico,
            _codigoIPFS
        );
    }

    function VisualizarResultadosLab(address _direccionAsegurado)
        public
        view
        returns (string memory _diagnostico, string memory _codigoIPFS)
    {
        _diagnostico = MappingResultadosServiciosLab[_direccionAsegurado]
            .diagnostico_servicio;
        _codigoIPFS = MappingResultadosServiciosLab[_direccionAsegurado]
            .codigo_IPFS;
    }
}
