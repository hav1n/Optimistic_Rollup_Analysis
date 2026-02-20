# From Cost Efficiency to Secure Design: Analyzing Operational Costs in Optimistic Rollups

This repository contains the datasets and SQL queries accompanying the paper:

> **From Cost Efficiency to Secure Design: Analyzing Operational Costs in Optimistic Rollups**  
> Hojung Yang, Suhyeon Lee, Seungjoo Kim  
> *Journal of Network and Computer Applications (JNCA)*

## Overview

The paper analyzes operational costs across 17 Optimistic Rollups classified into four decentralization levels. It evaluates sequencer infrastructure, validator infrastructure, data availability (DA) gas, and Layer 2 fee components using empirical data from deployed systems. The analysis includes cross-sectional comparison, a calibrated cost estimation model, and time-series measurements from Arbitrum One, OP Mainnet, and Base throughout 2024.

## Repository Structure

```
├── README.md
├── DESCRIPTION.md              # Detailed column-level documentation for each dataset
├── data/
│   ├── rollup_infrastructure.csv       # Table 1: Infrastructure & cost attributes (17 rollups)
│   ├── rollup_radar_normalized.csv     # Figure 2: Normalized radar chart values
│   ├── cost_estimation_inputs.csv      # Table 2 & Figure 3: Cost model parameters
│   └── timeseries/
│       ├── timeseries_arbitrum_one.csv  # Figure 4: Arbitrum One daily data (2024)
│       ├── timeseries_op_mainnet.csv    # Figure 5: OP Mainnet daily data (2024)
│       └── timeseries_base.csv         # Figure 6: Base daily data (2024)
├── queries/
│   └── timeseries_query.sql            # Dune Analytics SQL template (Appendix C)
└── LICENSE
```

## Dataset Summary

| File | Records | Period | Paper Reference |
|------|---------|--------|-----------------|
| `rollup_infrastructure.csv` | 17 rollups | Dec 2024 | Table 1 |
| `rollup_radar_normalized.csv` | 17 rollups | Dec 2024 | Figure 2 |
| `cost_estimation_inputs.csv` | 17 rollups | Dec 2024 | Table 2, Figure 3 |
| `timeseries_arbitrum_one.csv` | 366 days | Jan–Dec 2024 | Figure 4 |
| `timeseries_op_mainnet.csv` | 366 days | Jan–Dec 2024 | Figure 5 |
| `timeseries_base.csv` | 366 days | Jan–Dec 2024 | Figure 6 |

Detailed column definitions and usage notes are available in [`DESCRIPTION.md`](DESCRIPTION.md).

## Rollups Analyzed

The study covers the following 17 Optimistic Rollups across four decentralization levels:

| Level | Rollups |
|-------|---------|
| Level 1 (Minimally Supported) | DeBank Chain, Optopia |
| Level 2 (Enhanced Validator) | Blast, Mode Network, Lisk, Taiko, Kinto, Zora, Boba, Mint, SuperLumio, Metal |
| Level 3 (Incentivized) | Arbitrum One |
| Level 4 (Fully Decentralized) | Kroma, Base, OP Mainnet, Fuel v1 |

## Data Collection

- **Observation window:** December 2024 (cross-sectional data); January–December 2024 (time-series data)
- **On-chain data:** Dune Analytics (SQL queries in `queries/`), Etherscan (batch submission gas parsing)
- **Off-chain data:** Official documentation, L2Beat, developer forums, public dashboards
- **Infrastructure pricing:** AWS EC2 pricing as of December 2024

For full methodology, see Section 3 of the paper.

## Cost Estimation Model

The operational cost model (Section 5.1) decomposes monthly cost into three components:

```
C_operational = C_infra + B_DA + B_commit
```

where:
- **C_infra** = infrastructure cost (sequencer + validator nodes)
- **B_DA** = data availability gas cost
- **B_commit** = finalization commitment cost

Input parameters for reproducing Table 2 and Figure 3 are provided in `cost_estimation_inputs.csv`. Batching parameters are calibrated from observed batch counts: median intervals of ~46.60 min (Levels 1–2) and ~2.05 min (Levels 3–4).

## SQL Query

The time-series data were collected using the following Dune Analytics query template. Replace `{rollup}` with the chain table name and `{sequencer_address}` with the corresponding sequencer wallet address.

```sql
WITH tx_data AS (
    SELECT
        DATE_TRUNC('day', block_time) AS day,
        COUNT(*) AS tx_count,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS l2_fee_eth
    FROM {rollup}.transactions
    WHERE DATE(block_time) >= DATE('2024-01-01')
      AND DATE(block_time) < DATE('2025-01-01')
    GROUP BY 1
),
l1_gas AS (
    SELECT
        DATE_TRUNC('day', block_time) AS day,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS gas_cost_eth
    FROM ethereum.transactions
    WHERE "from" = {sequencer_address}
      AND DATE(block_time) >= DATE('2024-01-01')
      AND DATE(block_time) < DATE('2025-01-01')
    GROUP BY 1
)
SELECT
    tx_data.day,
    tx_data.tx_count,
    tx_data.l2_fee_eth,
    l1_gas.gas_cost_eth
FROM tx_data
LEFT JOIN l1_gas ON tx_data.day = l1_gas.day
ORDER BY tx_data.day
```

## Citation

If you use these datasets in your research, please cite:

```bibtex
@article{yang2025costefficiency,
  title={From Cost Efficiency to Secure Design: Analyzing Operational Costs in Optimistic Rollups},
  author={Yang, Hojung and Lee, Suhyeon and Kim, Seungjoo},
  journal={Journal of Network and Computer Applications},
  year={2025}
}
```
## License
This dataset is released under CC BY 4.0.

## Contact

- Hojung Yang — ghwjd0816@korea.ac.kr
- Suhyeon Lee — suhyeon@tokamak.network
- Seungjoo Kim — skim71@korea.ac.kr
