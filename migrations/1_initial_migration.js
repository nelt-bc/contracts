var AA = artifacts.require('Test');

module.exports = function (deployer) {
  // deployer.deploy(Token, "100000000000000000000000000000", { overwrite: false });
  deployer.deploy(AA);
};