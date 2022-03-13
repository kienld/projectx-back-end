const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = "gloom car weather upgrade clinic weather axis cotton velvet comfort spend seminar";
module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*' // match any netwrok id
    },
    testnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://data-seed-prebsc-2-s2.binance.org:8545`),
      network_id: 97,
      confirmations: 10
    },
  }
};