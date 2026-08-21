# Ejercicio 23 — FULLTEXT index

- **Nivel:** 4/5
- **Tema:** Avanzado de MySQL
- **Tiempo estimado:** 25 minutos

> ⚠️ **Requiere MySQL**: el índice FULLTEXT y `MATCH ... AGAINST` son específicos de
> MySQL. El `test.sh` requiere MySQL para validar este ejercicio.

## Enunciado

La tabla `articulos` ya existe con datos. Crea un índice FULLTEXT y haz una búsqueda.

1. Crea un índice FULLTEXT sobre las columnas `titulo` y `contenido`.
2. Busca artículos que contengan la palabra `MySQL` con `MATCH ... AGAINST`.
3. Muestra `titulo` y `contenido` de los resultados.

## Requisitos

- [ ] Usas `CREATE FULLTEXT INDEX`
- [ ] Usas `MATCH(titulo, contenido) AGAINST('MySQL')`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `CREATE FULLTEXT INDEX idx_ft ON articulos (titulo, contenido);`
- `WHERE MATCH(titulo, contenido) AGAINST('MySQL')` filtra por texto completo.
- En MySQL, el motor InnoDB soporta FULLTEXT desde la versión 5.6.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE FULLTEXT INDEX idx_ft ON articulos (titulo, contenido);
SELECT titulo, contenido FROM articulos
WHERE MATCH(titulo, contenido) AGAINST('MySQL');
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-04-avanzado/ejercicio-23-fulltext
bash test.sh
```
