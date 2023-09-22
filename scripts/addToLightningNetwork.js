async function main() {
    const [caller] = await ethers.getSigners();
    const contractAddress = "0x953cd84bb669b42fbec83ad3227907023b5fc4ff"; // Replace with your deployed contract's address
  
    // Get the Contract Factory
    const ContractFactory = await ethers.getContractFactory("RSKBridgeLightning");
  
    // Initialize the contract using the contract address
    const contract = ContractFactory.attach(contractAddress);
  
    // Set up the parameters
    const amount = ethers.utils.parseEther("0.01"); // Replace with your minimum amount in Ether
    const invoiceId = ethers.utils.formatBytes32String("123abc2"); // Replace with whatever number or string works for you
  
    // Send the transaction
    const tx = await contract.swapToLightningNetwork(amount, invoiceId, { value: amount });
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
  