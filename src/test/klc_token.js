const KLCToken = artifacts.require("KLCToken");
/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("KLCToken", function (accounts) {
  let instance;
  before('should setup the contract instance', async () => {
    instance = await KLCToken.deployed();
  });
  it('should return the list of accounts', async () => {
    console.log(accounts);
  });

  it('Test MINTER_ROLE ', async () => {
    await instance.grantRole(await instance.MINTER_ROLE.call(), accounts[1]);
    await instance.mint(accounts[1], 5000000000, {from: accounts[1]});
    console.log(await instance.hasRole(await instance.MINTER_ROLE.call(), accounts[1]));
    console.log("MINTER_ROLE: " + await instance.MINTER_ROLE.call());
  });

  it('Test transfer ', async () => {
    await instance.transfer(accounts[2], 1000, {from: accounts[1]});
    await instance.transfer(accounts[3], 1000, {from: accounts[1]});
    await instance.approve(accounts[3], 200, {from: accounts[2]});
    await instance.transferFrom(accounts[2], accounts[3], 100, {from: accounts[3]});
    const t0 = await instance.balanceOf.call(accounts[0]);
    const t1 = await instance.balanceOf.call(accounts[1]);
    const t2 = await instance.balanceOf.call(accounts[2]);
    const t3 = await instance.balanceOf.call(accounts[3]);
    console.log(t0.toNumber());
    console.log(t1.toNumber());
    console.log(t2.toNumber());
    console.log(t3.toNumber());
  });



});
