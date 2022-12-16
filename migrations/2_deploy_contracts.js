const storageNum = artifacts.require("StorageNum");
const token = artifacts.require("NUToken");

module.exports = function(deployer) {
	deployer.deploy(storageNum);
	deployer.deploy(token, "Test_Token", "TST", 1000);
};