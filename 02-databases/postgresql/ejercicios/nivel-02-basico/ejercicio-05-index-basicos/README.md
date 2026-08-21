# Ejercicio 05 — Índices básicos

- **Nivel:** 2/5
- **Tema:** Básico de PostgreSQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Índice en email de usuarios
2. Índice en isbn de libros
3. Índice compuesto en prestamos (usuario_id, fecha_prestamo)

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_libros_isbn ON libros(isbn);
CREATE INDEX idx_prestamos_usuario_fecha ON prestamos(usuario_id, fecha_prestamo);
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-02-basico/ejercicio-05-index-basicos
bash test.sh
```
