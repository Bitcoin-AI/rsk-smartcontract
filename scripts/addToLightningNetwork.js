async function main() {
    const [caller] = await ethers.getSigners();
    const contractAddress = "0x953cd84bb669b42fbec83ad3227907023b5fc4ff"; // Replace with your deployed contract's address
  
    // Get the Contract Factory
    const ContractFactory = await ethers.getContractFactory("RSKBridgeLightning");
  
    // Initialize the contract using the contract address
    const contract = ContractFactory.attach(contractAddress);
  
    // Set up the parameters
    const amount = 100; // Replace with your minimum amount in Ether
    // const invoiceId = ethers.utils.formatBytes32String(""); // Replace with whatever number or string works for you
  
    // Send the transaction
    const tx = await contract.swapToLightningNetwork(amount, "0xe276ae8f54d89973d41292b5965823f3d9e1486c9d5b2f7a53ca420c49ce287d", { value: amount });
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
  