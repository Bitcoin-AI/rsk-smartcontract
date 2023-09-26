async function main() {
    const [caller] = await ethers.getSigners();
    const contractAddress = "0x034b8AE121aB786A5262cB2082540B81eb2E340F"; // Replace with your deployed contract's address
  
    // Get the Contract Factory
    const ContractFactory = await ethers.getContractFactory("RSKBridgeLightning");
  
    // Initialize the contract using the contract address
    const contract = ContractFactory.attach(contractAddress);
  
    // Set up the parameters
    const amount = 1000000000000; // Replace with your minimum amount in Ether
    // const invoiceId = ethers.utils.formatBytes32String(""); // Replace with whatever number or string works for you
  
    // Send the transaction
    const tx = await contract.swapToLightningNetwork(amount, "ZaKFcgjS/1ztQufVGbkL0CboQlA2IsO/4BzatgwOciA=", { value: amount });
    console.log("Transaction sent:", tx.hash);
  
    // Wait for the transaction to be mined
    await tx.wait();
    console.log("Transaction confirmed:", tx.hash);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  