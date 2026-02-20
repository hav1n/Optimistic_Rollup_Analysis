# Dataset Description

This document describes each dataset included in this repository. All data correspond to the analysis presented in the paper *"From Cost Efficiency to Secure Design: Analyzing Operational Costs in Optimistic Rollups."*

---

## 1. `rollup_infrastructure.csv`

**Corresponds to:** Table 1

**Description:**  
Key infrastructure and cost attributes of 17 Optimistic Rollups, collected from official documentation, analytics platforms (L2Beat, Dune Analytics), community forums, and public blockchain data. Data reflects operational conditions during December 2024.

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `Rollup` | string | Name of the Optimistic Rollup |
| `Decentralization_Level` | int (1–4) | Classification level defined in Section 4.1 |
| `Stage` | int (0–2) | Maturity stage per L2Beat/Buterin framework (Section 2.2) |
| `Built_on` | string | Base technology stack (e.g., OP Stack, Arbitrum Nitro) |
| `Fraud_proof` | string | Fraud-proof mechanism type; `N/A` if not yet implemented |
| `CPU` | string | Required CPU specification for node operation |
| `RAM` | string | Required RAM specification |
| `SSD` | string | Required storage specification |
| `AWS_Instance` | string | Equivalent AWS EC2 instance type |
| `HW_Cost_USD_Month` | float | Monthly hardware cost in USD, based on AWS pricing (Dec 2024) |
| `Num_Sequencers` | int | Number of sequencer nodes (1 for all observed rollups) |
| `Num_Validators` | int or string | Number of validators; `Decentralized` indicates permissionless participation |
| `Tx_per_Month` | int | Transaction count during December 2024 |
| `DA_Gas_ETH` | float | Average DA gas cost per batch submission in ETH (Dec 2024) |
| `L2_Fee_USD` | float | Average per-transaction L2 fee in USD (Dec 2024) |
| `Incentive` | string | Validator incentive mechanism; empty if not applicable |

**Notes:**
- Fuel v1 values for DA gas and L2 fee are estimated from comparable rollups (see Section 3.4).
- DA gas costs were computed by extracting batch submissions from sequencer addresses via Etherscan.

---

## 2. `rollup_radar_normalized.csv`

**Corresponds to:** Figure 2

**Description:**  
Normalized cost components used to generate the radar charts in Figure 2. All values are log-transformed and Min-Max scaled to the range [1, 10] following the procedure described in Appendix B. These values are derived from the raw data in `rollup_infrastructure.csv`.

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `Rollup` | string | Name of the Optimistic Rollup |
| `Decentralization_Level` | int (1–4) | Classification level |
| `Sequencer` | float [1–10] | Normalized sequencer infrastructure cost |
| `Validator` | float [1–10] | Normalized validator infrastructure cost |
| `DA_Gas` | float [1–10] | Normalized data availability gas cost |
| `L2_Fee` | float [1–10] | Normalized Layer 2 transaction fee |
| `Net_Profit` | float [1–10] | Normalized net profit (revenue minus cost) |

**Normalization formula** (Appendix B):
```
X' = log(X + ε)
X_normalized = ((X' - min(X')) / (max(X') - min(X'))) × 9 + 1
```

---

## 3. `cost_estimation_inputs.csv`

**Corresponds to:** Table 2, Figure 3

**Description:**  
Input parameters for the operational cost estimation model defined in Section 5.1. These parameters, combined with the cost formulas (Equations 2–6), produce the estimated monthly costs in Table 2 and the cost curves in Figure 3.

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `Rollup` | string | Name of the Optimistic Rollup |
| `Decentralization_Level` | int (1–4) | Classification level |
| `TPS` | float | Observed transactions per second |
| `C_seq` | float | Monthly cost per sequencer node (USD) |
| `N_seq` | int | Number of sequencer nodes |
| `C_val` | float | Monthly cost per validator node (USD) |
| `N_val` | int | Number of validator nodes |
| `S_batch` | int | Batch size (transactions per batch): 1,000 for Levels 1–2; 1,500 for Levels 3–4 |
| `T_interval_min` | float | Median batch submission interval (minutes): 46.60 for Levels 1–2; 2.05 for Levels 3–4 |

**Usage:**  
To compute estimated monthly operational cost for a rollup, apply:
```
C_infra  = C_seq × N_seq + C_val × N_val
N_batch  = max(Tx_month / S_batch, T_month / T_interval)
B_DA     = N_batch × G_DA
B_commit = (N_batch / R_commit) × G_commit
C_total  = C_infra + B_DA + B_commit
```
where `G_DA` and `G_commit` are per-transaction gas costs in USD (derived from December 2024 average gas prices), and `R_commit` is the commit ratio (default: 1).

---

## 4–6. Time-Series Data

**Corresponds to:** Figures 4, 5, 6 and Section 5.2

### `timeseries_arbitrum_one.csv` — Arbitrum One (Figure 4)
### `timeseries_op_mainnet.csv` — OP Mainnet (Figure 5)
### `timeseries_base.csv` — Base (Figure 6)

**Description:**  
Daily aggregated transaction data for the full year 2024 (January 1 – December 31), collected via Dune Analytics SQL queries. These data support the time-series analysis of transaction volumes, L1 gas expenditure, and L2 fee dynamics in Section 5.2.

**Columns (identical across all three files):**

| Column | Type | Description |
|--------|------|-------------|
| `date` | string (YYYY-MM-DD) | Calendar date |
| `tx_count` | int | Total transactions processed on the rollup |
| `l2_fee_eth` | float | Average per-transaction L2 fee in ETH |
| `l1_gas_eth` | float | Total L1 gas expenditure by the sequencer in ETH |

**Coverage:** 366 daily observations per rollup (2024 is a leap year).

**SQL query template:** See Appendix C of the paper. The query joins rollup-side transaction data with Ethereum mainnet gas expenditure filtered by sequencer address.
