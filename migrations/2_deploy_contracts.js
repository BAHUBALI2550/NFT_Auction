var NumbersNFT = artifacts.require('NumbersNFT.sol');
var NFTDutchAuction = artifacts.require('NFTDutchAuction.sol');

module.exports = function(deployer) {
    deployer.deploy(NumbersNFT, 'NumbersNFT', 'NNFT').then(function() {
        return deployer.deploy(NFTDutchAuction, NumbersNFT.address);
    });
}; 