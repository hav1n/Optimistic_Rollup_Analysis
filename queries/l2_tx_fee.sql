SELECT 
  COUNT(*) AS tx_count,
  SUM(gas_used * gas_price)/1e18 AS l2_fee_eth
FROM {{Chain}}.transactions
WHERE block_time >= TIMESTAMP '2026-04-01'
  AND block_time < TIMESTAMP '2026-05-01'
