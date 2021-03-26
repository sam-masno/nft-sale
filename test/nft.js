const nft = artifacts.require("NFT");
const { PRICE, NAME, VERSION } = require('../nft.config.js');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("nft", function (accounts) {
  const [admin, user1, user2, user3] = accounts;
  it("should assert true", async function () {
    await nft.deployed();
    return assert.isTrue(true);
  });

  it('should assign admin on deployment', async () => {
    const instance = await nft.deployed();
    const isAdmin = await instance.isAdmin.call({from: admin});
    expect(isAdmin).to.equal(true);
  });

  it('rejects non admin accounts when onlyAdmin used', async () => {
    const instance = await nft.deployed();
    const isAdmin = await instance.isAdmin.call({from: user1}).catch(() => false);
    expect(isAdmin).to.equal(false);
  });

  it('sets price, version, and name on deployment', async () => {
    const instance = await nft.deployed();
    const price = (await instance.price.call()).toNumber();
    const name = await instance.name.call();
    const version = await instance.version.call();
    expect(price).to.equal(PRICE);
    expect(name).to.equal(NAME);
    expect(version).to.equal(VERSION);
  });

  it('mints new nft when paid exact price', async () => {
    const newNFT = 'Test NFT';
    const instance = await nft.deployed();
    const { logs: { '0': { args } } } = await instance.mintToken.call(newNFT);
    expect(args._owner).to.equal(admin);
    expect(args._name).to.equal(newNFT);
    console.log(args._id);
  })

});
