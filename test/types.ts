import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { Fixture } from "ethereum-waffle";
import { Lottery } from "../src/types/Lottery";
import { MoldNFT } from "../src/types/MoldNFT";

declare module "mocha" {
  export interface Context {
    lottery: Lottery;
    moldNft: MoldNFT;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: Signers;
  }
}

export interface Signers {
  admin: SignerWithAddress;
  alice: SignerWithAddress;
  bob: SignerWithAddress;
  eric: SignerWithAddress;
}
