# Ejercicio 03 — Particiones

- **Nivel:** 4/5
- **Tema:** Avanzado de PostgreSQL
- **Tiempo estimado:** 35 minutos

## Enunciado

1. Crear tabla particionada por rango (fecha)
2. Crear particiones mensuales
3. Insertar datos y confirmar que van a la partición correcta

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE prestamos_particionado (
    id SERIAL,
    libro_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_prestamo TIMESTAMP NOT NULL,
    fecha_devolucion DATE,
    PRIMARY KEY (id, fecha_prestamo)
) PARTITION BY RANGE (fecha_prestamo);

CREATE TABLE prestamos_2024_01 PARTITION OF prestamos_particionado
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE prestamos_2024_02 PARTITION OF prestamos_particionado
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

INSERT INTO prestamos_particionado (libro_id, usuario_id, fecha_prestamo) VALUES
    (1, 1, '2024-01-15'),
    (2, 2, '2024-02-10');

-- Confirmar en que particion cayo cada fila
SELECT tableoid::regclass AS particion, * FROM prestamos_particionado;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-04-avanzado/ejercicio-03-particiones
bash test.sh
```
