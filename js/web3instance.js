var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));

console.log('web3', web3);

web3.eth.defaultAccount = web3.eth.accounts[0];
