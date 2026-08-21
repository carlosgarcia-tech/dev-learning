# Ejercicio 17 — Foreign Key

- **Nivel:** 3/5
- **Tema:** Intermedio de MySQL
- **Tiempo estimado:** 25 minutos

## Enunciado

Las tablas `clientes` y `pedidos` ya existen, con una foreign key de `pedidos.cliente_id`
a `clientes.id`. Verifica la integridad referencial y haz una consulta válida.

1. Intenta insertar un pedido con `cliente_id = 999` (que no existe). Debe fallar.
2. Inserta un pedido válido: `cliente_id = 1`, `total = 99.99`.
3. Muestra `id`, `cliente_id`, `total` de todos los pedidos ordenados por `id`.

## Requisitos

- [ ] La solución intenta el INSERT inválido (el test lo gestiona de forma controlada)
- [ ] El INSERT válido se ejecuta correctamente
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un INSERT que viola una FK genera un error en MySQL. Para que el script continúe,
  puedes envolverlo en un bloque que ignore el error o comentarlo en la solución.
- El INSERT válido usa `cliente_id = 1` que sí existe en `clientes`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Este INSERT viola la foreign key (cliente 999 no existe).
-- El test.sh lo omite/envuelve para que no detenga la ejecución.
-- INSERT INTO pedidos (cliente_id, total) VALUES (999, 50.00);

-- INSERT válido (cliente 1 existe)
INSERT INTO pedidos (cliente_id, total) VALUES (1, 99.99);

SELECT id, cliente_id, total FROM pedidos ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-03-intermedio/ejercicio-17-foreign-key
bash test.sh
```
