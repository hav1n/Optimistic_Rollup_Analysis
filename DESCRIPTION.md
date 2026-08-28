# Dataset Description

Column-level documentation for the datasets in `data/`. All monetary gas values
are denominated in ETH unless stated otherwise; the paper converts to USD at
P_ETH = $2,252, the April 2026 monthly average.

## data/rollup_cross_section.csv

One row per rollup (17 rows, including the two discontinued chains).

| Column | Description |
|---|---|
| `Rollup` | Chain name, the join key across all files in this repository. |
| `Status` | `Active` or `Defunct` as of April 2026. |
| `Stage` | Maturity classification: L2Beat Stage 0--2, or U0/U1 for chains below Stage 0 (U1 has a fraud-proof mechanism, U0 does not). |
| `Built on` | Rollup stack (e.g., OP Stack, Arbitrum Nitro). |
| `Fraud-proof` / `Proof System` | Dispute mechanism and its implementation. |
| `Period` | Measurement month for this row. `Apr.26` for active rollups; discontinued rollups carry the last month with observable activity. |
| `CPU` / `RAM` / `SSD` | Documented node hardware requirements. Where the CPU count was not disclosed, 4 vCPUs are assumed (OP Stack default). |
| `Instance` | AWS EC2 instance matching the documented CPU/RAM requirement. |
| `USD/Month` | Per-node monthly cost: on-demand instance rate (us-east-1, hourly rate x 730 h) plus SSD at $0.08 per GB-month. **TB-denominated SSD values are priced as 1,024 GB** (e.g., OP Mainnet: $121.47 + 1,024 x $0.08 = $203.39). Exception: Blast's 1 TB requirement is priced as 100 GB in the source data; the figure is retained as collected (see README). |
| `#Sequencer` / `#Validator` | Operator-run node counts. For Morph, the validator count reflects the 8 actively operated challengers out of 38 registered. |
| `Tx/month` | Transactions over the row's measurement month. Facet v1 and DeBank Chain are scaled from a 19-day daily average due to incomplete explorer data. |
| `DA Gas (ETH)` | Monthly data-availability expenditure: calldata gas plus blob gas summed over every batch submission (see `da_decomposition_apr2026.csv` for the split). |
| `L2 Fee (ETH)` | Monthly Layer 2 transaction-fee revenue. |
| `Sequencer Address` | Layer 1 address used to extract batch submissions. Batcher EOAs are filtered as the transaction sender (`from`); inbox contracts (e.g., Arbitrum One, Morph) as the recipient (`to`). |

## data/da_decomposition_apr2026.csv

Calldata / blob decomposition of monthly DA cost, April 2026. Active rows are
ordered by blob share (ascending), matching Table V of the paper.

| Column | Description |
|---|---|
| `rollup` | Chain name (join key). |
| `status` | `active` (15 rows, reported in Table V) or `defunct` (2 rows). The defunct chains show only residual or zero activity in the April 2026 window and are excluded from Table V; their headline figures in the paper follow the `Period` column of the cross-section file. |
| `calldata_eth` | Monthly calldata gas expenditure. |
| `blob_eth` | Monthly blob gas expenditure (EIP-4844). |
| `total_da_eth` | Sum of the two components. |

Derived quantities in Table V follow as `blob share = blob_eth / total_da_eth`
and `DA/tx = total_da_eth / (Tx/month)`.

**Validation note.** For Morph, whose batches route through an inbox contract,
the decomposition was cross-checked with both the inbox-recipient filter and the
batcher-sender filter; the two agree within 0.02%. The batcher-filtered values
are reported.

## data/rollup_radar_normalized.csv

Inputs to the radar charts (Fig. 2). Per-transaction component values are
normalized by a log transform followed by min--max scaling to [1, 10], so no
single extreme value dominates the chart. The `Net Profit` and `Net Cost` axes
are normalized separately for each sign group and are comparable only within a
group (see the Fig. 2 caption).

## data/timeseries/{arbitrum_one, op_mainnet, base}.csv

Daily series, 1 January 2024 through 30 April 2026.

| Column | Description |
|---|---|
| `day` | UTC date. |
| `tx_count` | Daily Layer 2 transaction count. |
| `l2_fee_eth` | Daily Layer 2 fee revenue. |
| `da_gas_eth` | Daily Layer 1 data-availability expenditure (calldata + blob) of the chain's batcher. |

Values are raw daily observations; the seven-day moving average shown in Fig. 5
is applied by `figures/fig5_timeseries.py`, not in the data.

## queries/

- `da_gas_batches.sql` — extracts every batch submission of a given Layer 1
  address and sums calldata gas cost and blob fees per day. Placeholders and the
  sender/recipient filter convention are documented in the file header.
- `l2_tx_fee.sql` — daily transaction counts and Layer 2 fee revenue for a given
  chain table.

## figures/

Python scripts (pandas, numpy, matplotlib) that regenerate the figures from the
files above: `fig2_radar.py` (Fig. 2), `fig4_cost_breakdown.py` (Fig. 4),
`fig5_timeseries.py` (Fig. 5). Each script reads only files in `data/` and
writes a PDF to the working directory.
