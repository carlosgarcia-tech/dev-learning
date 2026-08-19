# Ejercicio 19 — Constraints

- **Nivel:** 4/5
- **Tema:** Avanzado de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Aplica PRIMARY KEY, FOREIGN KEY, UNIQUE
2. Aplica CHECK constraints
3. Aplica DEFAULT constraints
4. Aplica composite constraints

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

En SQLite las restricciones se definen directamente en el `CREATE TABLE` (no existe `ALTER TABLE ADD CONSTRAINT`). Además, para que las claves foráneas se apliquen hay que activar `PRAGMA foreign_keys = ON;`.

```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT UNIQUE,
    edad INTEGER CHECK (edad >= 18 AND edad <= 150),
    estado TEXT CHECK (estado IN ('activo', 'inactivo', 'suspendido')),
    creado TEXT,
    activo INTEGER DEFAULT 1
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
    fecha TEXT,
    total REAL CHECK (total >= 0),
    estado TEXT CHECK (estado IN ('pendiente', 'pagado', 'entregado', 'cancelado')),
    UNIQUE (cliente_id, fecha) -- Constraint compuesta
);
```

La verificación se hace con `SELECT` sobre `sqlite_master` (para mostrar el esquema aplicado), comprobaciones de integridad que deben devolver 0 y una prueba del `ON DELETE CASCADE`.

</details>
