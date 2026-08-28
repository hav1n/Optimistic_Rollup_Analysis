# Analysis on Operational Cost and Economic Sustainability of Optimistic Rollups

This repository contains the datasets, query templates, and figure scripts accompanying the paper:

> **Analysis on Operational Cost and Economic Sustainability of Optimistic Rollups**
> Hojung Yang, Suhyeon Lee, Seungjoo Kim
> *Under review at the IEEE Internet of Things Journal, 2026.*

## Overview

The paper measures the operational cost and fee revenue of 17 deployed Optimistic
Rollups (ORUs), classified by the L2Beat maturity framework (Stage 0--2, with
unclassified chains split into U0/U1 by the presence of a fraud-proof mechanism).
Monthly cost is decomposed as

```
C_total = C_node + C_DA
        = (c_comp + c_stor(S)) + (a_blob * V_blob + a_cd * V_cd) * P_ETH
```

where node cost covers compute and storage and data-availability (DA) cost covers
calldata and blob gas. The cross-section is measured over April 2026 (the most
recent complete month at collection; see the `Period` column for the two
discontinued rollups), and daily time series for Arbitrum One, OP Mainnet, and
Base span January 2024 through April 2026. The ETH price used throughout is
P_ETH = $2,252, the April 2026 monthly average.

## Repository Structure

```
├── README.md
├── DESCRIPTION.md                  # Column-level documentation for each dataset
├── LICENSE                         # CC BY 4.0
├── data/
│   ├── rollup_cross_section.csv    # 17 rollups: hardware, nodes, DA gas, fees
│   ├── da_decomposition_apr2026.csv# Calldata / blob split of DA cost
│   ├── rollup_radar_normalized.csv # Normalized values behind the radar charts
│   └── timeseries/
│       ├── arbitrum_one.csv
│       ├── op_mainnet.csv
│       └── base.csv
├── queries/
│   ├── da_gas_batches.sql          # Dune template: per-batch calldata + blob gas
│   └── l2_tx_fee.sql               # Dune template: daily tx count and L2 fees
└── figures/
    ├── fig2_radar.py
    ├── fig4_cost_breakdown.py
    └── fig5_timeseries.py
```

## Paper-to-File Mapping

| Paper object | Source in this repository |
|---|---|
| Table II (infrastructure and cost attributes) | `data/rollup_cross_section.csv` |
| Table V (calldata / blob decomposition) | `data/da_decomposition_apr2026.csv` |
| Fig. 2 (cost radar charts) | `data/rollup_radar_normalized.csv` + `figures/fig2_radar.py` |
| Fig. 4 (cost breakdown and cost vs. revenue) | `data/rollup_cross_section.csv`, `data/da_decomposition_apr2026.csv` + `figures/fig4_cost_breakdown.py` |
| Fig. 5 (daily time series) | `data/timeseries/*.csv` + `figures/fig5_timeseries.py` |
| DA gas measurement (Sections IV--V) | `queries/da_gas_batches.sql` |
| Transaction counts and L2 fees | `queries/l2_tx_fee.sql` |

Tables III, IV, VI--VIII and the thresholds of Section VI are derived from the
files above; the derivations (Spearman statistics, the alpha calibration, and the
break-even and crossover formulas) are specified in the paper.

## Data Collection

- **Cross-section window:** 1--30 April 2026. The two discontinued rollups are
  reported at the snapshot recorded in their `Period` field.
- **On-chain data:** Dune Analytics (templates in `queries/`), with chain-specific
  block explorers for rollups not indexed by Dune.
- **Off-chain data:** L2Beat (maturity classification, validator composition) and
  official operator documentation (hardware requirements).
- **Infrastructure pricing:** AWS us-east-1 on-demand EC2 rates at 730 hours per
  month plus gp3 storage at $0.08 per GB-month. TB-denominated requirements are
  priced as 1,024 GB. See `DESCRIPTION.md` for the per-column conventions.

**Known data caveat.** Blast's documented storage requirement (1 TB) is priced as
100 GB in its reported node cost; we retain the figure as collected and flag the
inconsistency, which shifts Blast's node cost by $72 per month and does not affect
any threshold in the paper.

## Reproducing the Queries

Both SQL templates run on [Dune Analytics](https://dune.com). Replace the
placeholders with the chain table name and the Layer 1 address given in the
`Sequencer Address` column of `data/rollup_cross_section.csv`. Batcher EOAs are
filtered as the transaction sender (`from`); inbox contracts are filtered as the
recipient (`to`). See the header comments of each query for details.

## Citation

```bibtex
@article{yang2026oru,
  title   = {Analysis on Operational Cost and Economic Sustainability of Optimistic Rollups},
  author  = {Yang, Hojung and Lee, Suhyeon and Kim, Seungjoo},
  journal = {IEEE Internet of Things Journal},
  year    = {2026},
  note    = {Under review}
}
```

## License

Released under CC BY 4.0. The figure scripts are provided under the same terms.

## Contact

- Hojung Yang — ghwjd0816@korea.ac.kr
- Suhyeon Lee — orion-alpha@korea.ac.kr
- Seungjoo Kim — skim71@korea.ac.kr
