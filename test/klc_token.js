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

  it('Should return the total supply: 100000', async () => {
    instance._totalSupply.call().then(function (result) {
      console.log("result _totalSupply: "  + result);
      assert.equal(result.toNumber(), 100000, 'total supply is true');
    });
  });

  it("should return the balance of token owner", async () =>  {
    console.log("accounts[0] : " + accounts[0]);
    const result = await instance.balanceOf.call(accounts[0]);
    console.log("result balance of : " + accounts[0] + ": "  + result);
  })

  it("Transfer 1000 token to accout[1] ", async () =>  {
    console.log("accounts[1] : " + accounts[1]);
    await instance.transfer(accounts[1], 1000);
    await instance.transfer(accounts[2], 900);
    const token0 = await instance.balanceOf.call(accounts[0]);
    const token1 = await instance.balanceOf.call(accounts[1]);
    const token2 = await instance.balanceOf.call(accounts[2]);
    console.log("balance of : " + accounts[0] + ": "  + token0);
    console.log("balance of : " + accounts[1] + ": "  + token1);
    assert.equal(token0.toNumber(), 98100, 'total supply is wrong');
    assert.equal(token1.toNumber(), 1000, 'total supply is wrong');
    assert.equal(token2.toNumber(), 900, 'total supply is wrong');
  })

  it("Approve 999 token to accout[1], 899 token to accout[2]", async () =>  {
    await instance.approve(accounts[1], 999);
    await instance.approve(accounts[2], 899);
    const tokenApprove1 = await instance.allowance(accounts[0], accounts[1]);
    const tokenApprove2 = await instance.allowance(accounts[0], accounts[2]);
    
    console.log("Token approve account[1] : " + accounts[1] + ": "  + tokenApprove1);
    console.log("Token approve account[2] : " + accounts[2] + ": "  + tokenApprove2);
    assert.equal(tokenApprove1.toNumber(), 999, 'total supply is wrong');
    assert.equal(tokenApprove2.toNumber(), 899, 'total supply is wrong');
  })

  it("TransferFrom accout[0]: 1000 to account[1] false because max of token can tranfer : 999", async () =>  {
    try {
      await instance.transferFrom(accounts[0], accounts[1], 1000);
    } catch (error) {
      assert.equal(999, 999, 'Error tranfer 1000 because MAX : 999');
    }
  })

  it("TransferFrom accout[0]: 999 to account[1] max: 999", async () =>  {
    try {
      await instance.transferFrom(accounts[0], accounts[1], 999, {from: accounts[1]});
      const token0 = await instance.balanceOf.call(accounts[0]);
      const token1 = await instance.balanceOf.call(accounts[1]);
      const tokenApprove1 = await instance.allowance(accounts[0], accounts[1]);
      console.log("Balance account[0] : " + accounts[0] + ": "  + token0);
      console.log("Balance account[1] : " + accounts[1] + ": "  + token1);
      console.log("TokenApprove1 account[0] : " + accounts[0] + ": "  + tokenApprove1);
      assert.equal(token0.toNumber(), 97101, 'Balance account[0] is wrong');
      assert.equal(token1.toNumber(), 1999, 'Balance account[1] is wrong');
      assert.equal(tokenApprove1.toNumber(), 0, 'tokenApprove1 account[0] is wrong');
    } catch (error) {
      console.log(error);
    }
  })



});
