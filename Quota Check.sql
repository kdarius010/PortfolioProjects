-- Checks If Sales Person met their Quota

WITH quota_checker AS 
(
SELECT 
d.employee_id,
d.deal_size,
sq.quota,
SUM(d.deal_size) OVER(PARTITION BY d.employee_id) as total_sale
FROM deals d
JOIN sales_quotas sq
ON d.employee_id = sq.employee_id
GROUP BY 
d.employee_id,
d.deal_size,
sq.quota
)

SELECT DISTINCT
employee_id,
deal_size,
quota,
total_sale,
CASE WHEN total_sale > quota THEN 'yes' ELSE 'no' END AS made_quota
FROM quota_checker
ORDER BY employee_id;