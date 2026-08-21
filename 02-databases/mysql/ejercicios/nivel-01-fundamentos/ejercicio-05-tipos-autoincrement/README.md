# Ejercicio 05 — Tipos y AUTO_INCREMENT

- **Nivel:** 1/5
- **Tema:** Fundamentos de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Crea una tabla `pedidos` con tipos de datos variados de MySQL y completa estas tareas:

1. Crea la tabla `pedidos` con:
   - `id`: `INT UNSIGNED AUTO_INCREMENT PRIMARY KEY`
   - `codigo`: `CHAR(6)` obligatorio
   - `cliente`: `VARCHAR(80)` obligatorio
   - `total`: `DECIMAL(10,2)` obligatorio
   - `estado`: `ENUM('pendiente','pagado','enviado')` con valor por defecto `'pendiente'`
   - `notas`: `TEXT` (admite NULL)
   - `creado_en`: `DATETIME` con valor por defecto `CURRENT_TIMESTAMP`
2. Inserta estos dos pedidos (sin indicar `id` ni `creado_en`):
   - codigo `P00001`, cliente `Ana`, total `150.75`, estado `pagado`, notas `Entrega urgente`
   - codigo `P00002`, cliente `Juan`, total `89.90`, estado `'pendiente'` (default), notas NULL
3. Muestra `id`, `codigo`, `cliente`, `total`, `estado` ordenados por `id`.

## Requisitos

- [ ] Usas tipos MySQL correctos (`CHAR`, `VARCHAR`, `DECIMAL`, `ENUM`, `TEXT`, `DATETIME`)
- [ ] `AUTO_INCREMENT` genera los IDs 1 y 2 automáticamente
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `ENUM` se declara como `ENUM('a','b','c') DEFAULT 'a'`.
- Si omites una columna con DEFAULT en el INSERT, toma el valor por defecto.
- `CURRENT_TIMESTAMP` como DEFAULT llena la fecha automáticamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE pedidos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  codigo CHAR(6) NOT NULL,
  cliente VARCHAR(80) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  estado ENUM('pendiente','pagado','enviado') DEFAULT 'pendiente',
  notas TEXT,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO pedidos (codigo, cliente, total, estado, notas) VALUES
  ('P00001', 'Ana', 150.75, 'pagado', 'Entrega urgente'),
  ('P00002', 'Juan', 89.90, DEFAULT, NULL);

SELECT id, codigo, cliente, total, estado FROM pedidos ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos/ejercicio-05-tipos-autoincrement
bash test.sh
```
