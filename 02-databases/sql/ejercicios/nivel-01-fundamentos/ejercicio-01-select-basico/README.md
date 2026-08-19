# Ejercicio 01 — SELECT Básico

- **Nivel:** 1/5
- **Tema:** Fundamentos de SQL
- **Tiempo estimado:** 15 minutos

## Enunciado

1. Crea una tabla `clientes` con: id, nombre, email, ciudad, fecha_registro
2. Inserta 5 clientes de ejemplo
3. Escribe consultas SELECT para:
   - Obtener todos los clientes
   - Obtener solo nombre y email
   - Obtener clientes de una ciudad específica

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Todos los clientes
SELECT * FROM clientes;

-- Nombre y email
SELECT nombre, email FROM clientes;

-- Clientes de Madrid
SELECT * FROM clientes WHERE ciudad = 'Madrid';
```

</details>
