const oracle = artifacts.require("oracle");

module.exports = function(deployer) {
    deployer.deploy(oracle);
};