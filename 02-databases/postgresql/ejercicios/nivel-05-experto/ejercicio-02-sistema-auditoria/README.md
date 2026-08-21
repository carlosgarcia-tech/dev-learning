# Ejercicio 02 — Sistema de Auditoría

- **Nivel:** 5/5
- **Tema:** Experto en PostgreSQL
- **Tiempo estimado:** 40 minutos

## Enunciado

1. Tabla central de auditoría
2. Trigger genérico reutilizable para varias tablas
3. Consultas típicas de auditoría (historial de un registro, resumen diario)

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

El material original aplicaba estos triggers a tablas `clientes`/`productos` que no existían en ese contexto (biblioteca). Se adaptó a las tablas reales del esquema (`libros`, `prestamos`) para que el ejercicio sea ejecutable.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE auditoria (
    id BIGSERIAL PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    registro_id INT NOT NULL,
    datos_viejos JSONB,
    datos_nuevos JSONB,
    usuario VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_auditoria_tabla_registro ON auditoria(tabla, registro_id);
CREATE INDEX idx_auditoria_fecha ON auditoria(fecha);

CREATE OR REPLACE FUNCTION auditar_cambio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria (tabla, operacion, registro_id, datos_nuevos, usuario)
        VALUES (TG_TABLE_NAME, 'INSERT', NEW.id, row_to_json(NEW), CURRENT_USER);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria (tabla, operacion, registro_id, datos_viejos, datos_nuevos, usuario)
        VALUES (TG_TABLE_NAME, 'UPDATE', NEW.id, row_to_json(OLD), row_to_json(NEW), CURRENT_USER);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria (tabla, operacion, registro_id, datos_viejos, usuario)
        VALUES (TG_TABLE_NAME, 'DELETE', OLD.id, row_to_json(OLD), CURRENT_USER);
        RETURN OLD;
    END IF;
END;
$$;

CREATE TRIGGER auditar_libros
AFTER INSERT OR UPDATE OR DELETE ON libros
FOR EACH ROW EXECUTE FUNCTION auditar_cambio();

CREATE TRIGGER auditar_prestamos
AFTER INSERT OR UPDATE OR DELETE ON prestamos
FOR EACH ROW EXECUTE FUNCTION auditar_cambio();

-- Genera actividad para probar los triggers
UPDATE libros SET cantidad = cantidad - 1 WHERE id = 1;
DELETE FROM prestamos WHERE id = 4;

-- Historial de un registro
SELECT * FROM auditoria WHERE tabla = 'libros' AND registro_id = 1 ORDER BY fecha DESC;

-- Resumen por dia/tabla/operacion
SELECT DATE_TRUNC('day', fecha) AS dia, tabla, operacion, COUNT(*) AS cantidad
FROM auditoria
GROUP BY DATE_TRUNC('day', fecha), tabla, operacion
ORDER BY dia DESC, tabla, operacion;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-05-experto/ejercicio-02-sistema-auditoria
bash test.sh
```
