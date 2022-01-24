import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import { MoldNFT } from "../../src/types/MoldNFT";
import { MoldNFT__factory } from "../../src/types/factories/MoldNFT__factory";

task("deploy:moldnft").setAction(async function (taskArguments: TaskArguments, { ethers }) {
  const moldNftFactory: MoldNFT__factory = <MoldNFT__factory>await ethers.getContractFactory("MoldNFT");
  const moldNFT: MoldNFT = <MoldNFT>await moldNftFactory.deploy();
  await moldNFT.deployed();
  console.log("MoldNFT deployed to: ", moldNFT.address);
});
