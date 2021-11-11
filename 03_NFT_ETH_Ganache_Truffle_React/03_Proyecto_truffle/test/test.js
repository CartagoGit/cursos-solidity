//Llamada al contrato
const notas = artifacts.require("contractNotas");

contract("notas", (accounts) => {
    var insertarNota = 9;
    var idAlumno01 = "12345X";
    var idAlumno02 = "54321Y";
    it("1. Funcion Evaluar:", async() => {
        //Desplegamos el contrato en una llamda asincrona
        let instance = await notas.deployed();
        //Variables a usar en el test

        // Llamada al métodfo de evaluación del Smart Contract
        const tx = await instance.evaluar(idAlumno01, insertarNota, {
            from: accounts[0],
        });
        //Imprimir valores:
        console.log("Contrato profesor: " + accounts[0]); //Direccion del profesor
        console.log("Transaccion de la evalucacion: ");
        console.log(tx); //Transaccion de la evaluacion academica
        //Comprobacion de la informacion de la Blockchain
        const nota_alumno = await instance.getNotas.call(idAlumno01, {
            from: accounts[0],
        });
        console.log("la nota del alumno es " + nota_alumno);
        assert.equal(nota_alumno, insertarNota);
    });

    it("2. Funcion Revision:", async() => {
        let instance = await notas.deployed();
        const rev01 = await instance.revisionNota(idAlumno01, { from: accounts[1] });
        const rev02 = await instance.revisionNota(idAlumno02, { from: accounts[2] });
        //console.log(rev);
        const id_alumno = await instance.getRevisiones.call({
            from: accounts[0],
        });
        assert.equal(idAlumno01, id_alumno[0]);
        assert.equal(idAlumno02, id_alumno[1]);
    });
});