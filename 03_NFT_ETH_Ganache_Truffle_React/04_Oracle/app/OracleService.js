//Llamadas a las dependencias del proyecto
const Web3 = require('web3');
const Tx = require('ethereumjs-tx');
const fetch = require('node-fetch');

//Llamadas a los archivos json
import contractJson from '../build/contracts/Oracle.json';

//instancia de web3
const web3 = new Web3('ws://127.0.0.1:7545');

//Informacion de direcciones de Ganache

//Sacado al migrar el contrato con truffle
const addressContract = "0x729eaCf939261410c6c81319dF60D8023Df81264";
const contractInstance = new web3.eth.Contract(contractJson.abi, addressContract);
// Sacado de Ganache
const privateKey = Buffer.from("d20a3f2cd685cc0b14e76280587c471919872d4c38b48da0fdadff72fd23c68d", "hex");
const address = "0x5174d00FcCA28351521CDd81F0E6E1EAfBd1559F";

//Obtener el numero del bloque
web3.eth.getBlockNumber().then(n => listenEvent(n - 1));

// function: listenEvent
function listenEvent(lastBlock) {
    contractInstance.events.__callbackNewData({}, { fromBlock: lastBlock, toBlock = "latest" }, (err, event) => {
        event ? updateData() : null;
        err ? console.log(err) : null;
    });
}

// function updateData()

function updateData() {
    /*start_date = 2015 - 09 - 07
    end_date = 2015 - 09 - 08
    api_key = DEMO_KEY
    API de la nasa SIN CAMBIAR:
    const url = "https://api.nasa.gov/neo/rest/v1/feed?start_date=START_DATE&end_date=END_DATE&api_key=API_KEY";
    */
    const url = "https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=API_KEY";

    //para acceder a la url
    fetch(url)
        .then(response => response.json())
        .then(json => setDataContract(json.element_count));
}

//Funcion: SetDataContact(_value)
function serDataContract(_value) {
    web3.eth.getBlockTransactionCount(address, (err, txNum) => {
        contractInstance.methods.setNumberAsteroids(
            _value.estimateGas({},
                (err, gasAmount) => {
                    let rawTx = {
                        nonce: web3.utils.toHex(txNum),
                        gasPrice: web3.utils.toHex(web.utils.toWei('1.4', 'gwei')),
                        gasLimit: web.utils.toHex(gasAmount),
                        to: addressContract,
                        value = '0x00',
                        data: contractInstance.methods.setNumberAsteroids(_value).encondeABI()
                    }
                    const tx = new Tx(rawTx);
                    tx.sign(privateKey);
                    const serializeTx = tx.serialize().toString('hex');
                    web3.eth.sendSignedTransaction('0x' + serializeTx);
                }
            )
        )
    })
}