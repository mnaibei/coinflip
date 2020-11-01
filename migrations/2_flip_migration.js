const  Coinflip= artifacts.require("Coinflip");

module.exports = function(deployer) {
  deployer.deploy(Coinflip);

};




/*const  Ownable= artifacts.require("Ownable");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
};*/
