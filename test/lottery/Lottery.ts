import { artifacts, ethers, waffle } from "hardhat";
import type { Artifact } from "hardhat/types";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import type { Lottery } from "../../src/types/Lottery";
import type { MoldNFT } from "../../src/types/MoldNFT";
import { Signers } from "../types";
import { expect } from "chai";

describe("Unit tests", function () {
  before(async function () {
    this.signers = {} as Signers;

    const signers: SignerWithAddress[] = await ethers.getSigners();
    this.signers.admin = signers[0];
    this.signers.alice = signers[1];
    this.signers.bob = signers[2];
    this.signers.eric = signers[3];
  });

  describe("Lottery", function () {
    beforeEach(async function () {
      const lotteryArtifact: Artifact = await artifacts.readArtifact("Lottery");
      const moldNftArtifact: Artifact = await artifacts.readArtifact("MoldNFT");

      this.lottery = <Lottery>await waffle.deployContract(this.signers.admin, lotteryArtifact);
      this.moldNft = <MoldNFT>await waffle.deployContract(this.signers.admin, moldNftArtifact);
    });

    it("should not work createLottery: nft initialization", async function () {
      await expect(this.lottery.connect(this.signers.admin).createLottery("Test Lottery")).to.be.revertedWith(
        "NFT should initialized!",
      );
    });

    it("should not work with createLottery: no permission", async function () {
      await this.lottery.connect(this.signers.admin).initializeNFT(this.moldNft.address);
      await expect(this.lottery.connect(this.signers.admin).createLottery("Test Lottery")).to.be.revertedWith(
        "No Permission",
      );
    });

    it("should not work with placeBid", async function () {
      await expect(this.lottery.connect(this.signers.admin).placeBid()).to.be.revertedWith("Admin can't place bid!");
    });

    it("should work with createLottery", async function () {
      await this.lottery.connect(this.signers.admin).initializeNFT(this.moldNft.address);
      await this.moldNft.connect(this.signers.admin).addMinter(this.lottery.address);
      const lotteryId = await this.lottery.connect(this.signers.admin).createLottery("Test Lottery");
      expect(lotteryId).to.not.equal(null);
    });

    it("should not work with placeBid", async function () {
      await expect(this.lottery.connect(this.signers.alice).placeBid()).to.be.revertedWith("Lottery not started!");
    });
  });
});
