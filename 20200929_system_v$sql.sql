SELECT *
FROM v$sql
WHERE sql_text LIKE '%SQL_TEST%';