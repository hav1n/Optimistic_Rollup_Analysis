# Sequencer / Batcher Addresses

This document lists the Ethereum L1 addresses used to filter Layer 1 gas expenditure in the time-series queries (`timeseries_query.sql`). These addresses are the batch submitter (batcher) accounts that post rollup transaction data to Ethereum mainnet.

## Time-Series Rollups (Figures 4–6)

| Rollup | Role | Ethereum L1 Address | Dune Table | Etherscan |
|--------|------|---------------------|------------|-----------|
| Arbitrum One | Batch Submitter | `0xC1b634853Cb333D3aD8663715b08f41A3Aec47cc` | `arbitrum` | [Link](https://etherscan.io/address/0xC1b634853Cb333D3aD8663715b08f41A3Aec47cc) |
| OP Mainnet | Batcher | `0x6887246668a3b87F54DeB3b94Ba47a6f63F32985` | `optimism` | [Link](https://etherscan.io/address/0x6887246668a3b87F54DeB3b94Ba47a6f63F32985) |
| Base | Batch Sender | `0x5050F69a9786F081509234F1a7F4684b5E5b76C9` | `base` | [Link](https://etherscan.io/address/0x5050F69a9786F081509234F1a7F4684b5E5b76C9) |

## Notes

- **Arbitrum One** uses a dedicated Batch Poster EOA operated by Offchain Labs. The batch poster submits compressed transaction batches to the SequencerInbox contract on Ethereum, using either EIP-4844 blob transactions or calldata depending on gas conditions.
- **OP Mainnet** and **Base** both use the OP Stack's `op-batcher` component. Each has a separate batcher address that posts channel frames to Ethereum.
- All addresses were verified against Etherscan labels and L2Beat operator documentation as of December 2024.
- The `l1_gas` CTE in `timeseries_query.sql` filters `ethereum.transactions` by the `"from"` field matching these addresses to capture all L1 gas expenditure associated with batch submissions.

## Verification

You can verify these addresses by:
1. Checking Etherscan labels (e.g., "Arbitrum: Batch Submitter", "Optimism: Batcher", "Base: Batch Sender")
2. Reviewing the respective L2Beat project pages under "Operator" sections
3. Inspecting recent transactions from these addresses, which should show calls to SequencerInbox or BatchInbox contracts
