# Ejercicio 03 — INSERT

- **Nivel:** 1/5
- **Tema:** Fundamentos de SQL
- **Tiempo estimado:** 15 minutos

## Enunciado

1. Inserta 3 nuevos productos
2. Inserta un producto con precio negativo (debe fallar)
3. Inserta un producto sin nombre (debe fallar)

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Insertar 3 productos
INSERT INTO productos (nombre, precio, stock) VALUES
    ('Monitor 27"', 349.99, 15),
    ('Teclado mecánico', 59.99, 30),
    ('Ratón inalámbrico', 34.99, 45);

SELECT * FROM productos ORDER BY id DESC LIMIT 3;

-- Producto con precio negativo (debe fallar: CHECK constraint)
-- INSERT INTO productos (nombre, precio, stock) VALUES ('Test', -10, 1);
-- Error esperado: CHECK constraint failed: precio >= 0

-- Producto sin nombre (debe fallar: NOT NULL constraint)
-- INSERT INTO productos (precio, stock) VALUES (100, 1);
-- Error esperado: NOT NULL constraint failed: productos.nombre
```

</details>
