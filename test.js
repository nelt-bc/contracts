const { TronWeb } = require('tronweb');
const deadline = Math.round(Date.now() / 1000) + 3600

const tronWeb = new TronWeb({
    privateKey: "a49021f8adb4c932fdc43b273100ad9e1437d856afbc6ddf8c7b69361446ccfc",
    fullNode: "https://nile.trongrid.io/wallet/",
    solidityNode: "https://nile.trongrid.io/walletsolidity/",
    eventServer: "https://nile.trongrid.io/"
})

const signature = tronWeb.trx._signTypedData({
    name: "AA",
    version: "1",
    chainId: 3448148188,
    verifyingContract: "TNS6uN2UWkkapzc4iDhC7W5xH82kkzBYgC",
}, {
    Permit: [
        { name: "token", type: "address" },
        { name: "owner", type: "address" },
        { name: "spender", type: "address" },
        { name: "value", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "deadline", type: "uint256" },
    ],
},
    {
        token: "TNPFZPscg3sXjRLRq5pj2KuWZRBP3E7815",
        owner: "TJPncMxDwoApkXjVU4oU6T28W5aUbWnGRG",
        spender: "TCvRUR6dqDRjwtJihAbaBwwh9wM6zsV3aL",
        value: "1000000000000000000",
        nonce: 1,
        deadline: 1746765566
    }, "0xa49021f8adb4c932fdc43b273100ad9e1437d856afbc6ddf8c7b69361446ccfc");

console.log(signature)