# Tercer Curso sobre Blockchains

## En este curso nos enfocaremos en crear una DApp con tokens NFT

### Los elementos y tipos de programación que usaremos seran:

- Ganache
- Truffle
- Solidity
- Node.js
- React
  
### Toda la informacion del repositorio del curso la podremos encontrar en:
https://github.com/joaneeet7/DApp

y en el recurso zip dentro de la carpeta recursos

## Recursos Ganache

Ganache-Cli:
https://docs.nethereum.com/en/latest/ethereum-and-clients/ganache-cli/

## Recursos Truffle

https://www.trufflesuite.com/docs/truffle/overview

Instalamos truffle desde node y la usamos truffle init para inicializar desde la carpeta del proyecto

### Documentación de Web3.js
https://web3js.readthedocs.io/en/v1.5.2/

#### Consola Truffle, comandos:
##### Empezamos reseteando ganache para volver a compilar desde truffle y posteriormente migrarlo reseteandolo para evitar problemas
truffle compile
truffle migration --reset


##### Una vez sale correcto, ya podemos empezar a usar la consola con "truffle console"
global = this 

## Oracle

### Dependencias para la app
npm i web3 
ethereumjs-tx 
cross-fetch 

##### En el curso usaron node-fetch pero al usarlo en la practica no paraba de dar problemas con los modigos js, asi que busque alternativa de dependencias