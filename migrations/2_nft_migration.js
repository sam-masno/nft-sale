const NFT = artifacts.require('NFT');
const { PRICE, NAME, VERSION } = require('../nft.config.js');

module.exports = async function (deployer) {
  const [admin] = await web3.eth.getAccounts();
  const price = await web3.utils.toWei('1', 'ether');
  const nft = await deployer.deploy(NFT, admin, NAME, VERSION, PRICE);
};
