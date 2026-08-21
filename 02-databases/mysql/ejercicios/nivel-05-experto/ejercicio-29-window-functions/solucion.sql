SELECT
    nombre,
    departamento,
    salario,
    RANK() OVER (PARTITION BY departamento ORDER BY salario DESC) AS ranking
FROM empleados
ORDER BY departamento ASC, salario DESC;
