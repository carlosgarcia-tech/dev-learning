# Ejercicio 03 — INSERT

- **Nivel:** 1/5
- **Tema:** INSERT, valores múltiples
- **Tiempo estimado:** 15 min

## Enunciado

Dada la tabla `estudiantes`, escribe los `INSERT` necesarios para:

1. Insertar un solo estudiante: `Sara`, `sara@example.com`, edad `19`, curso `'DAW'`.
2. Insertar de una sola vez (múltiples valores) a: `Iker` (21, `'DAM'`), `Nora` (20, `'ASIR'`) y `Diego` (23, `'DAW'`).

Después de ambos inserts debe haber **5 estudiantes** en la tabla (2 del dataset inicial + 1 + 3). Verifica con un `SELECT`.

## Schema inicial

```sql
CREATE TABLE estudiantes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT,
    edad INTEGER,
    curso TEXT
);

INSERT INTO estudiantes (id, nombre, email, edad, curso) VALUES
    (1, 'Elena', 'elena@example.com', 20, 'DAW'),
    (2, 'Hugo', 'hugo@example.com', 22, 'DAM');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `INSERT INTO tabla (columnas) VALUES (valores);`
- Pista 2: Para varios registros, separa cada grupo de valores con una coma: `VALUES (...), (...), (...);`.
- Pista 3: El `id` es `INTEGER PRIMARY KEY`, así que puedes omitirlo para que se autogenere, o asignarlo manualmente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Un solo estudiante (sin id, se autogenera)
INSERT INTO estudiantes (nombre, email, edad, curso)
VALUES ('Sara', 'sara@example.com', 19, 'DAW');

-- 2. Varios estudiantes a la vez
INSERT INTO estudiantes (nombre, email, edad, curso)
VALUES
    ('Iker', 'iker@example.com', 21, 'DAM'),
    ('Nora', 'nora@example.com', 20, 'ASIR'),
    ('Diego', 'diego@example.com', 23, 'DAW');

-- Verificación
SELECT id, nombre, edad, curso FROM estudiantes ORDER BY id;
````

</details>