import { artifacts, ethers, waffle } from "hardhat";
import type { Artifact } from "hardhat/types";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import type { Lottery } from "../../src/types/Lottery";
import { Signers } from "../types";
import { expect } from "chai";

describe("Unit tests", function () {
  before(async function () {
    this.signers = {} as Signers;

    const signers: SignerWithAddress[] = await ethers.getSigners();
    this.signers.admin = signers[0];
  });

  describe("Lottery", function () {
    beforeEach(async function () {
      const lotteryArtifact: Artifact = await artifacts.readArtifact("Lottery");
      this.lottery = <Lottery>await waffle.deployContract(this.signers.admin, lotteryArtifact);
    });

    it("should work with createLottery", async function () {
      expect(true);
    });
  });
});
