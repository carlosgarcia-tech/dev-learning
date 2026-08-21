-- Ejercicio de foreign key.
-- Este INSERT violaría la FK (cliente 999 no existe). Permanece comentado
-- porque detendría el script; el test.sh valida la FK por separado.
-- INSERT INTO pedidos (cliente_id, total) VALUES (999, 50.00);

-- INSERT válido (cliente 1 existe)
INSERT INTO pedidos (cliente_id, total) VALUES (1, 99.99);

SELECT id, cliente_id, total FROM pedidos ORDER BY id;
