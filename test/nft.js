const nft = artifacts.require("NFT");
const { PRICE, NAME, VERSION } = require('../nft.config.js');

contract("nft", function (accounts) {
  const [admin, user1, user2, user3, user4, user5] = accounts;
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

  it('mintToken creates new token, updates ownership and balances, emits logs', async () => {
    const newNFT = 'Test NFT';
    const instance = await nft.deployed();

    // mint new token and get logs
    const { logs: { '0': { args } } } = await instance.mintToken(newNFT, { from: admin, value: PRICE }).catch(err => console.log(err));

    // check log
    expect(args._owner).to.equal(admin);
    expect(args._name).to.equal(newNFT);
    const { _tokenId } = args;
    
    //check owner of token and balance of sender
    const _owner = await instance.ownerOf.call(parseInt(_tokenId));
    const _balance = (await instance.balanceOf.call(admin)).toNumber();
    expect(_owner).to.equal(admin);
    expect(_balance).to.equal(1);

  });

  it('safeTransfers from owner to recipient', async () => {
    const transferNFT = 'TransferNFT';
    const instance = await nft.deployed();
    // make new token and get token
    const mintLogs = await instance.mintToken(transferNFT, { from: user1, value: PRICE } ).catch(err => console.log(err));
    const mintId = mintLogs.logs[0].args._tokenId.toNumber();
    //transfer coin and get logs
    const { logs: { '0': { args } } } = await instance.safeTransferFrom(user1, user2, mintId, { from: user1 });
    const { _from, _to } = args;
    expect(_from).to.equal(user1);
    expect(_to).to.equal(user2);

    // get all balances
    const senderBalance = (await instance.balanceOf.call(user1)).toNumber();
    const recipientBalance = (await instance.balanceOf.call(user2)).toNumber();
    const owner = await instance.ownerOf.call(mintId);

    // assert balances
    expect(senderBalance).to.equal(0);
    expect(recipientBalance).to.equal(1);
    expect(owner).to.equal(user2);

  });

});
