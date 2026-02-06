# Sovereign Price Oracle

A robust, decentralized oracle system that allows a set of trusted or authorized nodes to report off-chain data (like asset prices) to the blockchain.

## Architecture
* **Data Submission:** Multiple independent nodes call `updatePrice`.
* **Consensus Logic:** The contract stores a sliding window of reports and calculates the **median** value to prevent a single malicious node from manipulating the price.
* **Security Checks:** Includes a "staleness" threshold—if no nodes report within a specific timeframe, the price is considered invalid to prevent DeFi protocols from using outdated data.



## Workflow
1. **Authorize Nodes:** The contract owner adds valid reporter addresses.
2. **Push Data:** Off-chain scripts fetch prices from APIs and push them to the contract.
3. **Consume:** External DeFi contracts call `getLatestPrice` to receive the verified, aggregated result.
