-- ============================================================
-- Time-Series Data Collection Query for Optimistic Rollups
-- ============================================================
-- Platform: Dune Analytics (https://dune.com)
-- Period: 2024-01-01 to 2024-12-31
-- Reference: Appendix C of the paper
--
-- Usage:
--   Replace {rollup} with the Dune chain table name
--   Replace {sequencer_address} with the batcher/batch poster address
--   See sequencer_addresses.md for the address mapping
-- ============================================================

WITH tx_data AS (
    SELECT
        DATE_TRUNC('day', block_time) AS day,
        COUNT(*) AS tx_count,
        SUM(
            CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)
        ) / 1e18 AS l2_fee_eth
    FROM {rollup}.transactions
    WHERE
        DATE(block_time) >= DATE('2024-01-01')
        AND DATE(block_time) < DATE('2025-01-01')
    GROUP BY 1
),

l1_gas AS (
    SELECT
        DATE_TRUNC('day', block_time) AS day,
        SUM(
            CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)
        ) / 1e18 AS gas_cost_eth
    FROM ethereum.transactions
    WHERE
        "from" = {sequencer_address}
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
ORDER BY tx_data.day;


-- ============================================================
-- Concrete queries used in this study
-- ============================================================

-- Arbitrum One
-- {rollup}             = arbitrum
-- {sequencer_address}  = 0xC1b634853Cb333D3aD8663715b08f41A3Aec47cc

-- OP Mainnet
-- {rollup}             = optimism
-- {sequencer_address}  = 0x6887246668a3b87F54DeB3b94Ba47a6f63F32985

-- Base
-- {rollup}             = base
-- {sequencer_address}  = 0x5050F69a9786F081509234F1a7F4684b5E5b76C9
