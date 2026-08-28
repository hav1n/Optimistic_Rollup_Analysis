-- ============================================================
-- DA Gas Measurement Query (2026-04 month)
-- ============================================================

WITH
debank AS (
    SELECT 'DeBank Chain' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x7aB7da0C3117D7Dfe0ABfAA8d8D33883f8477C74
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
optopia AS (
    SELECT 'Optopia' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x3D0Bf26E60a689a7Da5EA3ddAD7371F27f7671a5
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
blast AS (
    SELECT 'Blast' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x415c8893D514F9BC5211d36eEDA4183226b84AA7
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
mode AS (
    SELECT 'Mode Network' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x99199a22125034c808ff20f377d91187E8050F2E
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
lisk AS (
    SELECT 'Lisk' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0xa6Ea2f3299b63c53143c993d2d5E60A69Cd6Fe24
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
zora AS (
    SELECT 'Zora' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x625726c858dBF78c0125436C943Bf4b4bE9d9033
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
boba AS (
    SELECT 'Boba' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0xA4eD58737Fc5C4861C33410c29ECb1E2AF29d960
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
metal AS (
    SELECT 'Metal' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0xC94C243f8fb37223F3EB2f7961F7072602A51B8B
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
mint AS (
    SELECT 'Mint' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x560aFA9cF6B39D8C83938C77036E80807a56Da16
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
base AS (
    SELECT 'Base' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x5050F69a9786F081509234F1a7F4684b5E5b76C9
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
optimism AS (
    SELECT 'OP Mainnet' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x6887246668a3b87F54DeB3b94Ba47a6f63F32985
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
ink AS (
    SELECT 'Ink' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x500d7Ea63CF2E501dadaA5feeC1FC19FE2Aa72Ac
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
unichain AS (
    SELECT 'Unichain' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" = 0x2F60A5184c63ca94f82a27100643DbAbe4F3f7Fd
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
morph AS (
    SELECT 'Morph' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "from" IN (
        0x34E387B37d3ADEAa6D5B92cE30dE3af3DCa39796,
        0x6aB0E960911b50f6d14f249782ac12EC3E7584A0,
        0x76F91869161dC4348230D5F60883Dd17462035f4,
        0xBBA36CdF020788f0D08D5688c0Bee3fb30ce1C80,
        0xf0e11a8EA095Cc915f5a7e420928d396ed1Bb7e4
    )
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
taiko AS (
    SELECT 'Taiko' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "to" = 0x6f21C543a4aF5189eBdb0723827577e1EF57ef1f
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
morph_inbox AS (
    SELECT 'Morph (INBOX)' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "to" = 0x759894Ced0e6af42c26668076Ffa84d02E3CeF60
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
arbitrum AS (
    SELECT 'Arbitrum One' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "to" = 0x1c479675ad559DC151F6Ec7ed3FbF8ceE79582B6
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
),
facet AS (
    SELECT 'Facet v1' AS chain_name,
        SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE)) / 1e18 AS calldata_eth,
        SUM(
          COALESCE(
            CAST(cardinality(blob_versioned_hashes) AS DOUBLE) * 131072 * CAST(max_fee_per_blob_gas AS DOUBLE),
            0
          )
        ) / 1e18 AS blob_eth
    FROM ethereum.transactions
    WHERE "to" = 0x00000000000000000000000000000000000FacE7
      AND block_time >= TIMESTAMP '2026-04-01'
      AND block_time <  TIMESTAMP '2026-05-01'
)

SELECT chain_name, 
       COALESCE(calldata_eth, 0) AS calldata_eth, 
       COALESCE(blob_eth, 0) AS blob_eth,
       COALESCE(calldata_eth, 0) + COALESCE(blob_eth, 0) AS total_da_eth
FROM (
    SELECT * FROM debank
    UNION ALL SELECT * FROM optopia
    UNION ALL SELECT * FROM blast
    UNION ALL SELECT * FROM mode
    UNION ALL SELECT * FROM lisk
    UNION ALL SELECT * FROM taiko
    UNION ALL SELECT * FROM zora
    UNION ALL SELECT * FROM boba
    UNION ALL SELECT * FROM metal
    UNION ALL SELECT * FROM mint
    UNION ALL SELECT * FROM morph
    UNION ALL SELECT * FROM morph_inbox
    UNION ALL SELECT * FROM arbitrum
    UNION ALL SELECT * FROM base
    UNION ALL SELECT * FROM optimism
    UNION ALL SELECT * FROM ink
    UNION ALL SELECT * FROM unichain
    UNION ALL SELECT * FROM facet
)
ORDER BY total_da_eth DESC;
