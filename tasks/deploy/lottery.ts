import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import { Lottery } from "../../src/types/Lottery";
import { Lottery__factory } from "../../src/types/factories/Lottery__factory";

task("deploy:lottery").setAction(async function (taskArguments: TaskArguments, { ethers }) {
  const lotteryFactory: Lottery__factory = <Lottery__factory>await ethers.getContractFactory("Lottery");
  const lottery: Lottery = <Lottery>await lotteryFactory.deploy();
  await lottery.deployed();
  console.log("Lottery deployed to: ", lottery.address);
});
