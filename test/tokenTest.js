const { assert } = require('chai')

token = artifacts.require("NUToken");

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('testToken', (accounts) => {
    before(async () => {
        token = await token.deployed()

    })
    it('Matching Name', async () => {
        var token_name = await token.getName()
        var token_symbol = await token.getSymbol()
        var token_cap = await token.getCap()
        assert.equal(token_name,"Test_Token")
        assert.equal(token_symbol,"TST")
        assert.equal(token_cap,1000)
    })
    it('Matching Balance', async () => {
        const address = accounts[0];
        token_balance = await token.getBalance({from: address})
        assert.equal(token_balance,10)
        token_balance2 = await token.getBalance({from: accounts[1]})
        assert.equal(token_balance2,0)
    })
    it('Minting', async () => {
        const address = accounts[0];
        const address2 = accounts[1];
        await token.mint(address,10)
        await token.mint(address2,10)
        token_balance = await token.getBalance({from: address})
        assert.equal(token_balance,20)
        token_balance2 = await token.getBalance({from: address2})
        assert.equal(token_balance2,10)
    })
    it('Burning Token', async () => {
        const address = accounts[0];
        await token.burn(address,10)
        token_balance = await token.getBalance({from: address})
        assert.equal(token_balance,10)
    })
    it('Transfering Token', async () => {
        const address = accounts[0];
        const address2 = accounts[1];
        await token.safeTransfer(address, address2, 5)
        token_balance = await token.getBalance({from: address2})
        assert.equal(token_balance,15)
    })

})