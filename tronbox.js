const port = process.env.HOST_PORT || 9090

module.exports = {
  networks: {
    nile: {
      privateKey: "a49021f8adb4c932fdc43b273100ad9e1437d856afbc6ddf8c7b69361446ccfc",
      userFeePercentage: 100,
      feeLimit: 1000 * 1e6,
      fullHost: 'https://nile.trongrid.io',
      network_id: '3'
    },
    compilers: {
      solc: {
        version: '0.8.23'
      }
    }
  },
  // solc compiler optimize
  solc: {
    //   optimizer: {
    //     enabled: true,
    //     runs: 200
    //   },
    //   evmVersion: 'istanbul',
    //   viaIR: true,
  }
}
