const ERC1967Proxy = artifacts.require("ERC1967Proxy");
const AA = artifacts.require("AA");

module.exports = async function (deployer, network, accounts) {
  deployer.deploy(AA)
  
  const ownerAddress = "TJPncMxDwoApkXjVU4oU6T28W5aUbWnGRG";
  const encodedInitData = tronWeb.utils.abi.encodeParamsV2ByABI(
    {
      name: "initialize",
      type: "function",
      inputs: [{ type: "address", name: "_owner" }],
    },
    [ownerAddress]
  );
  // Deploy the minimal proxy pointing to logic
  await deployer.deploy(ERC1967Proxy, "TFqo1kT8PKCFuLZDAZdEDV2cYqYbmvPyUB", encodedInitData);
  const proxy = await ERC1967Proxy.deployed();
  console.log("Proxy:", proxy.address);
};
