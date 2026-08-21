# Ejercicios — MySQL

30 ejercicios organizados en 5 niveles de dificultad creciente, más un
proyecto final integrador. Cada ejercicio es autocontenido y se valida con
`bash test.sh`.

- [Nivel 1 — Fundamentos](./nivel-01-fundamentos/)
- [Nivel 2 — Básico](./nivel-02-basico/)
- [Nivel 3 — Intermedio](./nivel-03-intermedio/)
- [Nivel 4 — Avanzado](./nivel-04-avanzado/)
- [Nivel 5 — Experto](./nivel-05-experto/)
- [Proyecto final — Sistema de inventario y ventas](./proyectos/)

## Cómo funciona `test.sh`

Cada ejercicio incluye 5 archivos:

| Archivo | Contenido |
|---|---|
| `README.md` | Enunciado, requisitos, pistas y solución plegable |
| `schema.sql` | Esquema y datos de partida (sintaxis MySQL) |
| `solucion.sql` | Solución del ejercicio (sintaxis MySQL) |
| `expected.txt` | Salida esperada normalizada (columnas separadas por `\|`) |
| `test.sh` | Runner autocontenido |

`test.sh` detecta si MySQL está disponible y responde:

- **MySQL disponible**: crea una base de datos temporal real, ejecuta
  `schema.sql` y `solucion.sql`, compara la salida normalizada con
  `expected.txt` e imprime `OK Tests pasaron` o `FAIL Tests fallaron`.
- **MySQL no disponible**: usa **SQLite3** como motor de prueba. Adapta el
  SQL de MySQL a SQLite (elimina `ENGINE`, `AUTO_INCREMENT`→`AUTOINCREMENT`,
  `ENUM`→`TEXT`, etc.) y omite los bloques marcados con
  `-- MYSQL-ONLY START/END` (características exclusivas de MySQL como
  stored procedures, triggers, eventos, FULLTEXT). Si el ejercicio usa
  sintaxis que SQLite no soporta (p. ej. `YEAR()`, `DATE_FORMAT()`),
  indica que se requiere MySQL.

Variables de entorno opcionales para la conexión MySQL:

```bash
MYSQL_USER=root MYSQL_PASSWORD=[redacted] bash test.sh
MYSQL_HOST=127.0.0.1 MYSQL_PORT=3306 bash test.sh
```

## Ejecutar todos los ejercicios de un nivel

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos
for d in ejercicio-*/; do (cd "$d" && bash test.sh); done
```
