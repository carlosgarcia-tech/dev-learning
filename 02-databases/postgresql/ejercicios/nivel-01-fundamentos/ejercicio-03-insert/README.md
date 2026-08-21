# Ejercicio 03 — INSERT

- **Nivel:** 1/5
- **Tema:** Fundamentos de PostgreSQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Inserta 3 autores
2. Inserta 5 libros (cada uno con un autor existente)
3. Inserta 3 usuarios
4. Inserta 4 préstamos

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
INSERT INTO autores (nombre, nacionalidad, fecha_nacimiento) VALUES
    ('Gabriel Garcia Marquez', 'Colombiana', '1927-03-06'),
    ('J.K. Rowling', 'Britanica', '1965-07-31'),
    ('George R.R. Martin', 'Estadounidense', '1948-09-20');

INSERT INTO libros (titulo, autor_id, anio, isbn, genero, cantidad) VALUES
    ('Cien anios de soledad', 1, 1967, '978-0-06-088328-7', 'Realismo magico', 5),
    ('El amor en los tiempos del colera', 1, 1985, '978-0-14-102716-4', 'Romance', 3),
    ('Harry Potter y la piedra filosofal', 2, 1997, '978-0-7475-3269-9', 'Fantasia', 10),
    ('Harry Potter y la camara secreta', 2, 1998, '978-0-7475-3849-3', 'Fantasia', 8),
    ('Juego de tronos', 3, 1996, '978-0-553-10354-0', 'Fantasia epica', 6);

INSERT INTO usuarios (nombre, email, telefono) VALUES
    ('Ana Perez', 'ana@email.com', '123456789'),
    ('Juan Garcia', 'juan@email.com', '987654321'),
    ('Maria Lopez', 'maria@email.com', '456789123');

INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion) VALUES
    (1, 1, '2024-01-15', '2024-01-29'),
    (3, 2, '2024-01-20', NULL),
    (5, 3, '2024-01-22', '2024-02-05'),
    (2, 1, '2024-02-01', NULL);
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-03-insert
bash test.sh
```
