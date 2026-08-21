# Ejercicio 24 — Particionamiento

- **Nivel:** 4/5
- **Tema:** Avanzado de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL**: el particionamiento de tablas es específico de MySQL. El
> `test.sh` requiere MySQL para validar este ejercicio.

## Enunciado

Crea una tabla particionada por rango de fechas y consulta sus datos.

1. Crea una tabla `ventas_particionadas` con columnas `id INT` (PRIMARY KEY junto con
   `fecha`), `fecha DATE NOT NULL`, `producto VARCHAR(100)`, `monto DECIMAL(10,2)`.
   Particiona por `RANGE (YEAR(fecha))` con:
   - Partición `p2023`: valores < 2024
   - Partición `p2024`: valores < 2025
   - Partición `pmax`: resto
2. Inserta 3 ventas (una en 2023, una en 2024 y una en 2025).
3. Muestra `id`, `fecha`, `producto`, `monto` ordenados por `id`.

## Requisitos

- [ ] Usas `PARTITION BY RANGE (YEAR(fecha))`
- [ ] Defines 3 particiones (`p2023`, `p2024`, `pmax`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La clave primaria debe incluir la columna de partición: `PRIMARY KEY (id, fecha)`.
- `PARTITION BY RANGE (YEAR(fecha)) (PARTITION p2023 VALUES LESS THAN (2024), ...)`
- Los valores de `VALUES LESS THAN` se comparan con el resultado de `YEAR(fecha)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE ventas_particionadas (
  id INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  producto VARCHAR(100) NOT NULL,
  monto DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id, fecha)
) ENGINE=InnoDB
PARTITION BY RANGE (YEAR(fecha)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION pmax  VALUES LESS THAN MAXVALUE
);

INSERT INTO ventas_particionadas (fecha, producto, monto) VALUES
  ('2023-06-15', 'Mouse',   25.00),
  ('2024-03-20', 'Teclado', 45.00),
  ('2025-01-10', 'Monitor', 300.00);

SELECT id, fecha, producto, monto FROM ventas_particionadas ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-04-avanzado/ejercicio-24-particionamiento
bash test.sh
```
