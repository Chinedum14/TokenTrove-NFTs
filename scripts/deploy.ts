import { ethers } from "hardhat";


async function main() {
  // Get contract factory for the NFT contract.
  const MyNFT = await ethers.getContractFactory("TokenTrove");

  // Deploy contract to ganache.
  const myNFT = await MyNFT.deploy();

  console.log("TokenTrove deployed to: ", myNFT.address);
}



// Run the deployment script.
main().then(() => process.exit(0)).catch((error) => {
  console.error(error);
  process.exit(1);
})