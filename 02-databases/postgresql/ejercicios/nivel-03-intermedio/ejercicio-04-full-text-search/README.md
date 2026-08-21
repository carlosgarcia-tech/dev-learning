# Ejercicio 04 — Full-Text Search

- **Nivel:** 3/5
- **Tema:** Intermedio de PostgreSQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crear columna TSVECTOR
2. Indexarla con GIN
3. Buscar documentos
4. Rankear resultados por relevancia

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE articulos (
    id SERIAL PRIMARY KEY,
    titulo TEXT NOT NULL,
    contenido TEXT NOT NULL,
    documento TSVECTOR
);

INSERT INTO articulos (titulo, contenido) VALUES
    ('PostgreSQL y Full-Text Search', 'PostgreSQL ofrece potentes capacidades de busqueda de texto completo.'),
    ('Introduccion a las bases de datos', 'Las bases de datos son fundamentales en el desarrollo moderno.'),
    ('Como optimizar consultas SQL', 'La optimizacion de consultas es clave para el rendimiento.');

UPDATE articulos
SET documento =
    setweight(to_tsvector('spanish', titulo), 'A') ||
    setweight(to_tsvector('spanish', contenido), 'B');

CREATE INDEX idx_articulos_documento ON articulos USING GIN (documento);

SELECT * FROM articulos WHERE documento @@ to_tsquery('spanish', 'PostgreSQL');

SELECT titulo, ts_rank(documento, query) AS relevancia
FROM articulos, to_tsquery('spanish', 'PostgreSQL & SQL') AS query
WHERE documento @@ query
ORDER BY relevancia DESC;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-03-intermedio/ejercicio-04-full-text-search
bash test.sh
```
