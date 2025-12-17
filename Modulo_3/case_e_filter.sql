-- Uso de CASE
-- Total faturado por status
SELECT
  o.status,
  SUM(CASE WHEN o.status = 'DELIVERED' THEN o.total_amount ELSE 0 END) AS total_entregue,
  SUM(CASE WHEN o.status = 'PENDING' THEN o.total_amount ELSE 0 END) AS total_pendente,
  SUM(o.total_amount) AS total_geral
FROM orders o
GROUP BY o.status;

-- Uso de Filter
-- Total de faturamento pago e pendente por mes
SELECT
  DATE_TRUNC('month', o.order_date) AS mes,
  SUM(o.total_amount) AS total_geral,
  SUM(o.total_amount) FILTER (WHERE o.status = 'DELIVERED') AS total_entregue,
  SUM(o.total_amount) FILTER (WHERE o.status = 'PENDING') AS total_pendente
FROM orders o
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY mes;
