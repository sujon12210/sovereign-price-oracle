const ethers = require("ethers");
const axios = require("axios");

async function pushPrice(oracleAddress, privateKey) {
    const provider = new ethers.JsonRpcProvider("https://rpc.ankr.com/eth_sepolia");
    const wallet = new ethers.Wallet(privateKey, provider);
    const abi = ["function updatePrice(uint256 _price) external"];
    const contract = new ethers.Contract(oracleAddress, abi, wallet);

    // Fetch from Coingecko
    const res = await axios.get("https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd");
    const price = BigInt(Math.floor(res.data.ethereum.usd * 100)); // Scale by 100 for decimals

    const tx = await contract.updatePrice(price);
    await tx.wait();
    console.log(`Price pushed: ${price}`);
}
