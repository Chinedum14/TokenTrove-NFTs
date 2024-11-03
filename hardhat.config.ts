import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";

const config: HardhatUserConfig = {
  solidity: "0.8.27",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: ["0x5ddcea9e412605705159b195a85387b6026de418f8c7a428f93d8bbc17f2a8b6"]
    }
  }
};

export default config;
