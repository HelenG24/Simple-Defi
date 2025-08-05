import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";

/**
 * Deploys DappToken, LPToken, and TokenFarm, and sets TokenFarm as the owner of DappToken.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployTokenFarm: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("📡 Deploying contracts with account:", deployer);

  //
  // 1. Deploy DappToken
  //
  const dappTokenDeployment = await deploy("DappToken", {
    from: deployer,
    args: [deployer], // initialOwner
    log: true,
    autoMine: true,
  });
  const dappTokenAddress = dappTokenDeployment.address;
  console.log("✅ DappToken deployed to:", dappTokenAddress);

  //
  // 2. Deploy LPToken
  //
  const lpTokenDeployment = await deploy("LPToken", {
    from: deployer,
    args: [deployer], // initialOwner
    log: true,
    autoMine: true,
  });
  const lpTokenAddress = lpTokenDeployment.address;
  console.log("✅ LPToken deployed to:", lpTokenAddress);

  //
  // 3. Deploy TokenFarm
  //
  const tokenFarmDeployment = await deploy("TokenFarm", {
    from: deployer,
    args: [dappTokenAddress, lpTokenAddress],
    log: true,
    autoMine: true,
  });
  const tokenFarmAddress = tokenFarmDeployment.address;
  console.log("✅ TokenFarm deployed to:", tokenFarmAddress);

  //
  // 4. Transfer ownership of DappToken to TokenFarm
  //
  const dappToken = await ethers.getContractAt("DappToken", dappTokenAddress);
  const currentOwner = await dappToken.owner();

  if (currentOwner.toLowerCase() !== tokenFarmAddress.toLowerCase()) {
    const transferTx = await dappToken.transferOwnership(tokenFarmAddress);
    await transferTx.wait();
    console.log("🔑 Ownership of DappToken transferred to TokenFarm");
  } else {
    console.log("ℹ️ DappToken is already owned by TokenFarm");
  }
};

export default deployTokenFarm;
deployTokenFarm.tags = ["All"];
