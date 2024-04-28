SELECT project_name,
         CASE
          WHEN budget > 0 AND budget < 100000 THEN 1
          WHEN budget >= 100000 AND budget < 200000 THEN 2
          WHEN budget >= 200000 AND budget < 300000 THEN 3
          ELSE 4
         END budget_weight
        FROM project;