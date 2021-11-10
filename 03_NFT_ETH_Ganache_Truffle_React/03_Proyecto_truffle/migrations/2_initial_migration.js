const notas = artifacts.require("contractNotas");

module.exports = function (deployer) {
  deployer.deploy(notas);
};
