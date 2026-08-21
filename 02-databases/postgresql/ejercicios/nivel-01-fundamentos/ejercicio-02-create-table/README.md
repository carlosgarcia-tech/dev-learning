# Ejercicio 02 — Create Table

- **Nivel:** 1/5
- **Tema:** Fundamentos de PostgreSQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Crea las siguientes tablas:

1. `autores`: id, nombre, nacionalidad, fecha_nacimiento
2. `libros`: id, titulo, autor_id, anio, isbn, genero, cantidad
3. `usuarios`: id, nombre, email, telefono, fecha_registro
4. `prestamos`: id, libro_id, usuario_id, fecha_prestamo, fecha_devolucion

Aplica las restricciones apropiadas (PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK).

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

Se renombró la columna `año` a `anio` en todo el curso: la ñ en nombres de columna obliga a usar comillas dobles en cada consulta (`"año"`) o a fijar el encoding/locale del cliente; `anio` evita ese problema por completo.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE autores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50),
    fecha_nacimiento DATE
);

CREATE TABLE libros (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor_id INT NOT NULL REFERENCES autores(id) ON DELETE CASCADE,
    anio INT CHECK (anio >= 1450 AND anio <= EXTRACT(YEAR FROM CURRENT_DATE)),
    isbn VARCHAR(20) UNIQUE NOT NULL,
    genero VARCHAR(50),
    cantidad INT DEFAULT 1 CHECK (cantidad >= 0)
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prestamos (
    id SERIAL PRIMARY KEY,
    libro_id INT NOT NULL REFERENCES libros(id) ON DELETE CASCADE,
    usuario_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_prestamo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_devolucion DATE,
    CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo::DATE)
);
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-02-create-table
bash test.sh
```
