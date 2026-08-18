# Proyectos integradores

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles. Están ordenados de menor a mayor complejidad y cada uno tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente.

| # | Proyecto | Dificultad | Conceptos |
|---|---|---|---|
| 1 | Gestor de tareas CLI | ⭐⭐ | CLI, JSON, CRUD, validaciones |
| 2 | Mini blog con PDO | ⭐⭐⭐⭐ | PDO/SQLite, CRUD, sesiones, validaciones |
| 3 | **[PROYECTO FINAL — Blog de gestión de artículos](proyecto-final/)** | ⭐⭐⭐⭐⭐ | PHP puro, persistencia, auth por sesión, validaciones, MVC, tests |

---

## Proyecto 1 — Gestor de tareas CLI

**Dificultad:** ⭐⭐ (nivel 02-03)

Una aplicación de consola que gestiona tareas persistidas en `tareas.json`.

### Fase 1 — CRUD básico

- [ ] Comandos `agregar "<descripcion>"`, `listar`, `completar <id>` y `eliminar <id>`.
- [ ] Persistir en `tareas.json` con `json_encode`/`json_decode`.
- [ ] Cada tarea: `{ id, descripcion, completada }` con ids incrementales.

### Fase 2 — Validación y filtros

- [ ] Rechazar descripciones vacías (usa `throw` + try/catch).
- [ ] Comando `pendientes` que liste solo las no completadas.
- [ ] Comando `resumen` que muestre total y completadas.

### Fase 3 — Robustez

- [ ] Manejar `tareas.json` ausente o corrupto (devuelve lista vacía y avisa).
- [ ] Comando `exportar <archivo>` que escriba un resumen en texto plano.

---

## Proyecto 2 — Mini blog con PDO

**Dificultad:** ⭐⭐⭐⭐ (nivel 04-05)

Una mini aplicación web con **PDO + SQLite**: artículos con estado `publicado` y comentarios.

### Fase 1 — Modelo y CRUD

- [ ] Esquema SQL: `articulos (id, titulo, contenido, publicado, creado_en)` y `comentarios (id, articulo_id, autor, texto, creado_en)`.
- [ ] Funciones CRUD de artículos con `prepare`/`execute` y placeholders nombrados.
- [ ] `listarPublicados()` para la portada y `obtenerArticulo(id)` para el detalle.

### Fase 2 — Comentarios y búsqueda

- [ ] `agregarComentario()` validando autor y texto no vacíos.
- [ ] Mostrar `contarComentarios()` junto a cada artículo.
- [ ] `buscarArticulos(texto)` con `LIKE` sobre título y contenido.

### Fase 3 — Transacciones y robustez

- [ ] Eliminar un artículo borra también sus comentarios dentro de una transacción.
- [ ] Modo `ERRMODE_EXCEPTION` y captura de `PDOException` con mensajes claros.
- [ ] Preparar el esquema con `CREATE TABLE IF NOT EXISTS` al arrancar.

---

## Proyecto 3 — PROYECTO FINAL: Blog de gestión de artículos

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05, exigente)

El proyecto que cierra la ruta: un **blog completo en PHP puro** (sin frameworks, sin Composer) para gestionar artículos con usuarios autenticados. Integra **todo** lo aprendido:

- **PHP puro** con front controller (`public/index.php`), enrutador y controladores (MVC).
- **Persistencia en archivo JSON** con repositorio (`Almacenamiento`).
- **Autenticación por sesión** con `password_hash`/`password_verify` y control de roles.
- **Validaciones** exhaustivas en artículos, comentarios y credenciales.
- **Vistas** generadas con plantillas propias.
- **Suite de tests CLI** que solo pasa cuando el proyecto está completo.

### Requisitos clave

- `login`/`logout` por sesión; solo el admin crea/publica, los visitantes comentan.
- CRUD de artículos con estados `borrador`/`publicado`.
- Comentarios validados y vinculados a artículos.
- Todo persistido en `data/datos.json` tras cada mutación.
- **Cero dependencias**: solo PHP 8 estándar.

### Entrega

- **Especificación completa** (contexto, requisitos funcionales/no funcionales, fases, **30 criterios de aceptación**, rúbrica): [`proyecto-final/README.md`](proyecto-final/README.md).
- **Punto de partida con TODOs**: [`proyecto-final/starter/`](proyecto-final/starter/).
- **Suite de tests** que debe pasar el 100%: [`proyecto-final/tests/`](proyecto-final/tests/).

```bash
cd proyecto-final/tests
php ejecutar.php        # debe pasar el 100% cuando el proyecto esté completo
```

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar.
- Vuelve a las [guías](../../../) o a los ejercicios del nivel correspondiente si algo se te atasca.
- En el proyecto final, implementa en este orden: `app/autoload.php` → `app/Almacenamiento.php` → `app/ValidacionException.php` + `app/Validador.php` → `app/Blog.php` → `app/Sesion.php` → `app/Auth.php` → `app/Enrutador.php` → `public/index.php` → vistas → tests.