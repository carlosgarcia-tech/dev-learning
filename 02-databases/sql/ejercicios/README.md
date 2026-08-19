# Ejercicios — Curso de SQL

30 ejercicios prácticos organizados en 5 niveles de dificultad, más un proyecto final.

Cada ejercicio incluye:
- `README.md` — enunciado, requisitos y solución explicada
- `schema.sql` — esquema de datos de ejemplo
- `solucion.sql` — solución de referencia
- `expected.txt` — salida esperada al ejecutar la solución
- `test.sh` — script para verificar automáticamente la solución

## Niveles

| Nivel | Tema | Ejercicios |
|-------|------|------------|
| [Nivel 1 — Fundamentos](./nivel-01-fundamentos/) | SELECT, WHERE, INSERT, UPDATE, DELETE, funciones agregadas, LIKE | 01–06 |
| [Nivel 2 — Básico](./nivel-02-basico/) | JOINs, GROUP BY/HAVING, subconsultas, CASE, LIMIT | 07–12 |
| [Nivel 3 — Intermedio](./nivel-03-intermedio/) | Joins múltiples, window functions, CTEs, vistas, normalización | 13–18 |
| [Nivel 4 — Avanzado](./nivel-04-avanzado/) | Constraints, índices, transacciones, lógica con triggers, optimización | 19–24 |
| [Nivel 5 — Experto](./nivel-05-experto/) | Modelado, migraciones, datos relacionales complejos, reportes, concurrencia, mini CRM | 25–30 |
| [Proyecto Final](./proyectos/) | Sistema de gestión de biblioteca completo | — |

## Requisitos técnicos

- **Todos los ejercicios** son compatibles con **SQLite** — solo necesitas el cliente `sqlite3`.
- Cada `test.sh` aplica `schema.sql` + `solucion.sql` sobre una base SQLite temporal y compara la salida con `expected.txt`.
- El proyecto final usa triggers de SQLite y sus tests son autocontenidos (`bash tests/test-01-estructura.sh`, etc.).

## Cómo usar cada ejercicio

```bash
cd nivel-01-fundamentos/ejercicio-01-select-basico
cat README.md          # Lee el enunciado
# ...intenta resolverlo en solucion.sql...
bash test.sh            # Verifica tu solución
```
