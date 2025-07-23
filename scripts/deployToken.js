const hre = require("hardhat");

async function main() {
  // Define constructor arguments
  const cap = "1000000000"; // 1 Billion tokens
  const reward = "50";       // 50 tokens per block/transaction

  // Get the contract factory
  const RupeeToken = await hre.ethers.getContractFactory("RupeeToken");

  // Start deployment, passing constructor arguments
  console.log("Deploying RupeeToken...");
  const rupeeToken = await RupeeToken.deploy(cap, reward);

  // Wait for the deployment to be confirmed
  await rupeeToken.waitForDeployment();

  // Log the deployed contract's address
  const deployedAddress = await rupeeToken.getAddress();
  console.log(`RupeeToken deployed to: ${deployedAddress}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});