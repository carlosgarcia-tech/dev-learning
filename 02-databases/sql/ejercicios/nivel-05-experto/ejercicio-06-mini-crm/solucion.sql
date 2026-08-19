-- Mini CRM. El dashboard se implementa como una vista y el seguimiento como
-- una consulta con subconsultas. SQLite no tiene CURRENT_DATE - INTERVAL;
-- la ventana de 30 días se expresa con un literal de fecha (determinista).

-- Dashboard: KPIs del CRM en una vista
CREATE VIEW vista_dashboard_crm AS
SELECT
    (SELECT COUNT(*) FROM contactos) AS total_contactos,
    (SELECT COUNT(DISTINCT empresa) FROM contactos) AS total_empresas,
    (SELECT COUNT(*) FROM oportunidades WHERE etapa = 'cerrada_ganada') AS ventas_cerradas,
    ROUND(COALESCE((SELECT SUM(monto) FROM oportunidades WHERE etapa = 'cerrada_ganada'), 0), 2) AS total_ventas,
    (SELECT COUNT(*) FROM interacciones WHERE fecha > '2024-03-01') AS interacciones_30d;

-- Resultado del dashboard
SELECT * FROM vista_dashboard_crm;

-- Consulta de seguimiento: oportunidades activas por contacto, con el
-- número y la fecha de su última interacción. Los contactos sin interacción
-- aparecen primero (NULLS FIRST, soportado por SQLite 3.30+).
SELECT
    c.nombre,
    c.empresa,
    o.nombre AS oportunidad,
    o.etapa,
    ROUND(o.monto, 2) AS monto,
    (SELECT COUNT(*) FROM interacciones WHERE contacto_id = c.id) AS total_interacciones,
    (SELECT MAX(fecha) FROM interacciones WHERE contacto_id = c.id) AS ultima_interaccion
FROM contactos c
INNER JOIN oportunidades o ON c.id = o.contacto_id
WHERE o.etapa NOT IN ('cerrada_ganada', 'cerrada_perdida')
ORDER BY ultima_interaccion NULLS FIRST, c.nombre, o.id;