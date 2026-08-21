START TRANSACTION;
UPDATE cuentas SET saldo = saldo - 500 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 500 WHERE id = 2;
COMMIT;
SELECT id, titular, saldo FROM cuentas ORDER BY id;
