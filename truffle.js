module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    ganache: {
      host: "172.26.96.1",
      port: 7545,
      network_id: "5777",
      from: "0xf29382750A9D59c51b968ADB96982D85CA59a7BB", // account address from which to deploy
      gas: 6721975,
    }
  },
  compilers: {
    solc: {
      version: "0.4.24"
    }
  }
};