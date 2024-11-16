var NumbersNFT = artifacts.require('contracts\NumbersNFT.sol');
var NFTAuction = artifacts.require('contracts\NFTAuction.sol');

module.exports = function(deployer) {
    deployer.deploy(NumbersNFT, 'NumbersNFT', 'NNFT').then(function() {
        return deployer.deploy(NFTAuction, NumbersNFT.address);
    });
}; 