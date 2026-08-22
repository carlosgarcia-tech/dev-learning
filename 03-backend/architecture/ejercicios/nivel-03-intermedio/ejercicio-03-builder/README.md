# Ejercicio 03 — Implementar Builder

- **Nivel:** 3/5
- **Tema:** Patrón Builder (construcción paso a paso)
- **Tiempo estimado:** 30 min

## Enunciado

Implementa un `QueryBuilder` que construya una consulta SQL paso a paso con una API fluida (method chaining). El objetivo es evitar constructores con muchos parámetros y permitir variantes opcionales.

El archivo `solucion.py` debe contener:

- Una clase `QueryBuilder` con métodos `select(cols)`, `from_(tabla)`, `where(cond)`, `limit(n)`, `order_by(col)`.
- Cada método devuelve `self` (para encadenar).
- Un método `build()` que devuelve el SQL final como string.
- Soporta múltiples `where` (se unen con `AND`).

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `QueryBuilder` con los métodos select, from_, where, limit, order_by
- [ ] Cada método devuelve `self` (method chaining)
- [ ] `build()` devuelve un string SQL válido
- [ ] Múltiples `where` se unen con `AND`
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Constructor inicializa `_select="*"`, `_from=""`, `_where=[]`, `_limit=None`, `_order=""`.
- `where(cond)` hace `self._where.append(cond); return self`.
- `build()`: empieza con `SELECT cols FROM tabla`, añade `WHERE` si hay conds, `ORDER BY`, `LIMIT`.
- Ejemplo: `QueryBuilder().select("id").from_("users").where("a=1").where("b=2").limit(10).build()` → `"SELECT id FROM users WHERE a=1 AND b=2 LIMIT 10"`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
class QueryBuilder:
    def __init__(self):
        self._select = "*"
        self._from = ""
        self._where = []
        self._limit = None
        self._order = ""

    def select(self, cols):
        self._select = cols
        return self

    def from_(self, tabla):
        self._from = tabla
        return self

    def where(self, cond):
        self._where.append(cond)
        return self

    def order_by(self, col):
        self._order = col
        return self

    def limit(self, n):
        self._limit = n
        return self

    def build(self):
        sql = f"SELECT {self._select} FROM {self._from}"
        if self._where:
            sql += " WHERE " + " AND ".join(self._where)
        if self._order:
            sql += f" ORDER BY {self._order}"
        if self._limit is not None:
            sql += f" LIMIT {self._limit}"
        return sql
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
