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

  it('should return the name', async () => {
    const instance = await KLCToken();
  });
});
