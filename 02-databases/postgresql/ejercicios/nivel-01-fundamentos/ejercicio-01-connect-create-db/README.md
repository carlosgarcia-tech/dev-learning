# Ejercicio 01 — Connect y Create DB

- **Nivel:** 1/5
- **Tema:** Fundamentos de PostgreSQL
- **Tiempo estimado:** 15 minutos

## Enunciado

1. Crea un esquema llamado `biblioteca` dentro de la base de datos de pruebas
2. Crea una tabla mínima `configuracion` dentro de ese esquema
3. Inserta un registro de ejemplo
4. Verifica que el esquema y la tabla existen

> Nota: en el material original este ejercicio pedía `CREATE DATABASE`, pero
> `test.sh` ya crea y selecciona la base de datos de pruebas antes de correr
> `init.sql`/`solucion.sql` (no se puede hacer `CREATE DATABASE` dentro de
> una transacción de psql -f de forma fiable en todos los entornos). Por eso
> aquí se practica la creación de un **esquema**, que es el siguiente nivel
> de la jerarquía y sí es seguro de crear desde dentro de la base de datos
   ya conectada.

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Crear esquema
CREATE SCHEMA IF NOT EXISTS biblioteca;

-- Crear tabla mínima dentro del esquema
CREATE TABLE biblioteca.configuracion (
    clave VARCHAR(50) PRIMARY KEY,
    valor VARCHAR(200) NOT NULL
);

-- Insertar un registro de ejemplo
INSERT INTO biblioteca.configuracion (clave, valor)
VALUES ('nombre_biblioteca', 'Biblioteca Municipal');
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-connect-create-db
bash test.sh
```
