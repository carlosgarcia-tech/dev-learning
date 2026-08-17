# Ejercicio 02 — WHERE y orden

- **Nivel:** 1/5
- **Tema:** WHERE, operadores, ORDER BY, LIMIT
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `productos`, escribe las siguientes consultas:

1. Los productos con precio **menor a 20**, ordenados de menor a mayor precio.
2. Los productos de la categoría `'libros'` o con precio **mayor o igual a 50**.
3. Los **3 productos más caros** de toda la tabla.

Resultado esperado: la consulta 1 devuelve 3 productos, la consulta 3 devuelve exactamente 3 filas.

## Schema inicial

```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL NOT NULL
);

INSERT INTO productos (id, nombre, categoria, precio) VALUES
    (1, 'Cuaderno A5', 'papeleria', 2.50),
    (2, 'Boligrafo azul', 'papeleria', 1.20),
    (3, 'Libro de SQL', 'libros', 29.99),
    (4, 'Teclado mecanico', 'informatica', 85.00),
    (5, 'Mouse inalambrico', 'informatica', 19.90),
    (6, 'Libro de Python', 'libros', 39.50),
    (7, 'Monitor 24 pulgadas', 'informatica', 149.00),
    (8, 'Carpeta de archivo', 'papeleria', 5.75);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `WHERE precio < 20` y `ORDER BY precio ASC` (el `ASC` es opcional, es el orden por defecto).
- Pista 2: Combina condiciones con `OR` y `>=`. Recuerda que los textos van entre comillas simples.
- Pista 3: Ordena con `ORDER BY precio DESC` y limita con `LIMIT 3`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Precio menor a 20, de menor a mayor
SELECT nombre, precio
FROM productos
WHERE precio < 20
ORDER BY precio ASC;

-- 2. Categoria 'libros' o precio >= 50
SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'libros' OR precio >= 50;

-- 3. Los 3 productos más caros
SELECT nombre, precio
FROM productos
ORDER BY precio DESC
LIMIT 3;
````

</details>