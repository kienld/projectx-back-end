const KLCToken = artifacts.require("KLCToken");

module.exports = function (deployer) {
  deployer.deploy(KLCToken);
};
