//Llamada al contrato
const notas = artifacts.require("contractnotas");

//Funcion para desplegar contrato
async function desplegarContrato(_contrato){
    return _contrato.deployed();
}

contract ("notas", accounts =>{
    it ('Funcion Evaluar:', async ()=>{
        //Desplegamos el contrato en una llamda asincrona
        let instance = await desplegarContrato(notas);
        //Variables a usar en el test
        var insertarNota= 9;
        var idAlumno= "12345X";
        // Llamada al métodfo de evaluación del Smart Contract
        const tx = await instance.evaluar(idAlumno, insertarNota, {from:accounts[0]});
        //Imprimir valores:
        console.log("Contrato profesor: "+accounts[0]); //Direccion del profesor
        console.log("Transaccion de la evalucacion: ");
        console.log(tx); //Transaccion de la evaluacion academica
        //Comprobacion de la informacion de la Blockchain
        const nota_alumno = await instance.getNotas.call(idAlumno, {from: accounts[0]});
        console.log("la nota del alumno es "+nota_alumno);
        assert.equal(nota_alumno, insertarNota);
    });
});