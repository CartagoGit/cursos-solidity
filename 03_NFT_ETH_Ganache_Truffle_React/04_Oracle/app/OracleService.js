//Llamadas a las dependencias del proyecto
const Web3 = require("web3");
const Tx = require("ethereumjs-tx").Transaction;
const fetch = require("cross-fetch");

//Llamadas a los archivos json
const contractJson = require("../build/contracts/Oracle.json");

//instancia de web3
const web3 = new Web3("ws://127.0.0.1:7545");

//Informacion de direcciones de Ganache

//Sacado al migrar el contrato con truffle
const addressContract = "0x57f23ae8B895Ec10221CA7932736A07C6F79376A";
const contractInstance = new web3.eth.Contract(
  contractJson.abi,
  addressContract
);
// Sacado de Ganache
const privateKey = Buffer.from(
  "d20a3f2cd685cc0b14e76280587c471919872d4c38b48da0fdadff72fd23c68d",
  "hex"
);
const address = "0x5174d00FcCA28351521CDd81F0E6E1EAfBd1559F";

//Obtener el numero del bloque
web3.eth.getBlockNumber().then((n) => listenEvent(n - 1));

// function: listenEvent
function listenEvent(lastBlock) {
  contractInstance.events.__callbackNewData(
    {},
    { fromBlock: lastBlock, toBlock: "latest" },
    (err, event) => {
      event ? updateData() : null;
      err ? console.log(err) : null;
    }
  );
}

// function updateData()

function updateData() {
  /*start_date = 2015 - 09 - 07
          end_date = 2015 - 09 - 08
          api_key = DEMO_KEY
          API de la nasa SIN CAMBIAR:
          const url = "https://api.nasa.gov/neo/rest/v1/feed?start_date=START_DATE&end_date=END_DATE&api_key=API_KEY";
          */
  const url =
    "https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY";

  //para acceder a la url
  fetch(url)
    .then((response) => response.json())
    .then((json) => setDataContract(json.element_count));
}

//Funcion: SetDataContact(_value)
function setDataContract(_value) {
  
  web3.eth.getTransactionCount(address, (err, txNum) => {
    //let nonce =  web3.eth.getTransactionCount(address);
    contractInstance.methods
      .setNumAsteroids(_value)
      .estimateGas({}, (err, gasAmount) => {
        let rawTx = {
          nonce: web3.utils.toHex(txNum),
          gasPrice: web3.utils.toHex(web3.utils.toWei("1.4", "gwei")),
          gasLimit: web3.utils.toHex(gasAmount),
          to: addressContract,
          value: "0x00",
          data: contractInstance.methods.setNumAsteroids(_value).encodeABI(),
        };
        console.log(txNum);
        console.log(rawTx);
        const tx = new Tx(rawTx);
        tx.sign(privateKey);
        const serializedTx = tx.serialize().toString("hex");
        web3.eth.sendSignedTransaction("0x" + serializedTx);
      });
  });
}
