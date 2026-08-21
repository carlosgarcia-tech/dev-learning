# Ejercicio 20 — Trigger

- **Nivel:** 4/5
- **Tema:** Avanzado de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL**: los triggers son específicos de MySQL (sintaxis
> `DELIMITER`, `CREATE TRIGGER`, `NEW`, `OLD`). El `test.sh` requiere MySQL para
> validar este ejercicio.

## Enunciado

Las tablas `productos` y `auditoria` ya existen. Crea un trigger que registre cada
nuevo producto en la auditoría.

1. Crea un trigger `AFTER INSERT` sobre `productos` que inserte en `auditoria` el
   `producto_id`, la `accion = 'INSERT'` y el `nombre` del producto.
2. Inserta un producto: nombre `Webcam`, precio `60.00`.
3. Muestra el contenido de `auditoria` (columnas: `producto_id`, `accion`, `nombre`).

## Requisitos

- [ ] Usas `CREATE TRIGGER ... AFTER INSERT ... FOR EACH ROW`
- [ ] El trigger usa `NEW.id` y `NEW.nombre`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `NEW` contiene los valores del nuevo producto insertado.
- `CREATE TRIGGER trg AFTER INSERT ON productos FOR EACH ROW BEGIN ... END`
- Dentro del trigger: `INSERT INTO auditoria (producto_id, accion, nombre) VALUES (NEW.id, 'INSERT', NEW.nombre);`

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
DELIMITER //
CREATE TRIGGER trg_auditar_insert
AFTER INSERT ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (producto_id, accion, nombre) VALUES (NEW.id, 'INSERT', NEW.nombre);
END //
DELIMITER ;

INSERT INTO productos (nombre, precio) VALUES ('Webcam', 60.00);
SELECT producto_id, accion, nombre FROM auditoria ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-04-avanzado/ejercicio-20-trigger
bash test.sh
```
