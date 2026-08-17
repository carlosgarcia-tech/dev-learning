# PROYECTO FINAL — Blog de gestión de artículos

> El proyecto que cierra la ruta de PHP. Un blog completo en **PHP puro** (sin frameworks, sin Composer, sin dependencias) que integra todo lo aprendido: persistencia en archivo, autenticación por sesión, validaciones, enrutado con patrón MVC y una suite de tests que **solo pasa cuando el proyecto está completo y correcto**.

---

## 1. Contexto

Un pequeño medio digital quiere publicar artículos en la web. Necesita:

- **Visitantes** que lean los artículos publicados y dejen comentarios.
- **Autores registrados** que gestionen el contenido.
- Un **admin** que lo controle todo (crear, editar, publicar o eliminar artículos y moderar el blog).

La restricción principal: **cero dependencias**. Nada de frameworks ni paquetes de terceros. Todo se construye con PHP 8 estándar: el front controller, el enrutador, los controladores, las plantillas, la capa de persistencia y las validaciones.

El estado de la aplicación vive en un **único archivo JSON** (`data/datos.json`) que se crea la primera vez que se escribe. Cada mutación lee el archivo, modifica la estructura en memoria y lo vuelve a escribir — un "repositorio" sencillo que puedes sustituir después por PDO.

## 2. Requisitos funcionales

### RF-01 — Portada y lectura pública
- `GET /` muestra los artículos **publicados**, del más reciente al más antiguo.
- `GET /articulo/{id}` muestra el detalle de un artículo publicado con sus comentarios. Si no existe o es un borrador → 404.
- `GET /buscar?q=...` busca por título o contenido entre los artículos publicados.

### RF-02 — Comentarios
- `POST /articulo/{id}/comentar` crea un comentario (visitantes y usuarios).
- Solo se pueden comentar artículos **publicados** y existentes.
- El autor es obligatorio o se usa `Anónimo`; el texto se valida.

### RF-03 — Autenticación
- `GET /registro` y `POST /registro` crean una cuenta con rol `autor`.
- `GET /login` y `POST /login` inician sesión; `GET /logout` la cierra.
- Las contraseñas se guardan con `password_hash` y se verifican con `password_verify`.
- La sesión guarda `usuario_id`, `usuario_nombre` y `usuario_rol`.

### RF-04 — Panel de administración (solo admin)
- `GET /admin` lista todos los artículos (borradores y publicados) con su nº de comentarios.
- `GET /admin/articulos/nuevo` y `POST /admin/articulos` crean un artículo (borrador o publicado).
- `GET /admin/articulos/{id}/editar` y `POST /admin/articulos/{id}` lo editan.
- `POST /admin/articulos/{id}/eliminar` lo elimina **junto con sus comentarios**.
- Cualquier acceso a `/admin...` sin sesión de admin → 403.

### RF-05 — Errores y redirecciones
- Respuestas 200, 302/303 (redirección tras mutación), 401 (login fallido), 403 (prohibido), 404 (no encontrado) y 422 (validación fallida).
- Los errores de validación se muestran en la propia página.

## 3. Requisitos no funcionales

- **RNF-01 — Sin dependencias:** solo PHP 8 estándar (extensión `json` y `filter` del core; sin Composer, sin frameworks, sin PDO obligatorio).
- **RNF-02 — Seguridad:** contraseñas con `password_hash`/`password_verify`; todo dato mostrado pasa por `htmlspecialchars`; sesión iniciada con `session_start()`.
- **RNF-03 — Persistencia:** todo se guarda en `data/datos.json` tras **cada** mutación; el archivo se crea automáticamente; un archivo ausente o corrupto no rompe la app.
- **RNF-04 — Manejo de errores:** excepciones de dominio (`ValidacionException`) capturadas en el front controller; `RuntimeException` para fallos de infraestructura.
- **RNF-05 — Arquitectura:** front controller único (`public/index.php`), separación en `app/` (modelo) y `vistas/` (plantillas), enrutador con controladores.
- **RNF-06 — Tests:** la suite `tests/ejecutar.php` solo pasa (exit 0) cuando el proyecto está completo y correcto.
- **RNF-07 — Consistencia de datos:** eliminar un artículo borra sus comentarios; los ids son incrementales e inmutables.

## 4. Arquitectura

```
proyecto-final/
├── README.md            # esta especificación
├── starter/             # punto de partida con TODOs
│   ├── app/             # capa de dominio (sin código web)
│   │   ├── autoload.php             # autoload simple (completo)
│   │   ├── Almacenamiento.php       # persistencia JSON
│   │   ├── Sesion.php               # envoltorio de $_SESSION
│   │   ├── ValidacionException.php  # excepción de dominio (completa)
│   │   ├── Validador.php            # validaciones estáticas
│   │   ├── Blog.php                 # artículos y comentarios
│   │   ├── Auth.php                 # usuarios, sesión y roles
│   │   └── Enrutador.php            # enrutado GET/POST + {params}
│   ├── public/
│   │   └── index.php                # front controller (único punto de entrada)
│   ├── vistas/                      # plantillas (layout, inicio, articulo, admin/...)
│   └── data/                        # aquí se crea datos.json
└── tests/
    └── ejecutar.php     # suite de aserciones CLI
```

Flujo de una petición: `public/index.php` → `Enrutador::despachar()` → controlador (usa `Blog`/`Auth`) → respuesta `[status, vista, datos]` → plantilla en `vistas/`.

## 5. Fases de implementación

### Fase 1 — Autoload y almacenamiento
`autoload.php` está completo. Implementa `Almacenamiento`: leer/guardar JSON, estructura inicial, tolerancia a archivo corrupto.

### Fase 2 — Validaciones
Implementa `Validador` (estático) y `ValidacionException`. Todos los métodos lanzan `ValidacionException` con mensaje claro en español.

### Fase 3 — Blog (artículos)
Implementa `Blog::crearArticulo`, `listarArticulos`, `obtenerArticulo`, `actualizarArticulo` y `eliminarArticulo` con ids incrementales y ordenación por `id` desc.

### Fase 4 — Comentarios y búsqueda
`agregarComentario` (solo artículos publicados), `listarComentarios`, `contarComentarios` y `buscarArticulos` (coincidencia parcial en minúsculas).

### Fase 5 — Autenticación
Implementa `Sesion` y `Auth`: registro con `password_hash`, login con `password_verify`, logout, `usuarioActual()`, `rolActual()` y `esAdmin()`.

### Fase 6 — Enrutador y front controller
`Enrutador::get/post/despachar` y después `public/index.php`: registra todas las rutas de los RF, despacha la petición, lanza `session_start()`, protege `/admin`, renderiza la vista correcta y devuelve los códigos HTTP adecuados.

### Fase 7 — Endurecimiento y tests
Revisa seguridad (escapado, 403 en admin, validaciones), que cada mutación guarde en disco, y ejecuta la suite hasta que pase el 100%.

## 6. Criterios de aceptación

### Estructura y persistencia
- [ ] AC-01 El proyecto tiene `README.md`, `starter/app/`, `starter/public/`, `starter/vistas/`, `starter/data/` y `tests/`.
- [ ] AC-02 `autoload.php` carga cualquier clase de `app/` por nombre de archivo.
- [ ] AC-03 `Almacenamiento::leerTodo()` devuelve la estructura inicial sin archivo y tolera JSON corrupto.
- [ ] AC-04 `Almacenamiento::guardarTodo()` crea directorios si faltan y persiste el JSON.
- [ ] AC-05 Los ids de usuarios, artículos y comentarios son incrementales (`siguiente_id`) y únicos.
- [ ] AC-06 Cada mutación (crear/editar/eliminar/comentar/registrar) guarda en disco.

### Validaciones
- [ ] AC-07 El título es obligatorio y no supera los 100 caracteres.
- [ ] AC-08 El contenido es obligatorio y tiene al menos 10 caracteres.
- [ ] AC-09 El comentario no puede estar vacío ni superar los 500 caracteres.
- [ ] AC-10 El usuario tiene 3-20 caracteres alfanuméricos o `_`; la contraseña tiene al menos 6 caracteres.
- [ ] AC-11 `validarEmail()` distingue correos válidos de inválidos.
- [ ] AC-12 Las validaciones lanzan `ValidacionException` con mensaje en español.

### Artículos y comentarios
- [ ] AC-13 Se pueden crear artículos como borrador o publicado.
- [ ] AC-14 `listarArticulos()` ordena por id desc; `listarArticulos(true)` solo publicados.
- [ ] AC-15 `obtenerArticulo()` devuelve el artículo o `null`.
- [ ] AC-16 `actualizarArticulo()` devuelve `true`/`false` según exista el id y valida los datos.
- [ ] AC-17 `eliminarArticulo()` borra el artículo **y sus comentarios**, y devuelve `false` si no existía.
- [ ] AC-18 Solo se comentan artículos existentes y publicados.
- [ ] AC-19 `contarComentarios()` y `listarComentarios()` devuelven los datos correctos.
- [ ] AC-20 `buscarArticulos()` encuentra por título o contenido (sin distinción de mayúsculas) y, por defecto, solo publicados.

### Autenticación y sesión
- [ ] AC-21 El registro crea el usuario con `password_hash` y rol `autor` por defecto.
- [ ] AC-22 No se permiten nombres de usuario duplicados ni credenciales inválidas.
- [ ] AC-23 `login()` verifica con `password_verify` y guarda id/nombre/rol en la sesión.
- [ ] AC-24 `logout()` destruye la sesión y `estaAutenticado()` pasa a `false`.
- [ ] AC-25 `usuarioActual()` devuelve el usuario de la sesión (o `null`); `rolActual()` y `esAdmin()` distinguen roles.
- [ ] AC-26 `Sesion` funciona con `$_SESSION` en web y con un array inyectado en los tests.

### Enrutado y front controller
- [ ] AC-27 El enrutador distingue GET/POST, captura `{id}` y devuelve 404 con vista `no-encontrada` cuando no coincide.
- [ ] AC-28 `public/index.php` inicia la sesión, carga el autoload, usa `data/datos.json` y despacha la URI real.
- [ ] AC-29 Las rutas `/admin*` exigen sesión de admin (403 en caso contrario).
- [ ] AC-30 La suite `php tests/ejecutar.php` (desde `proyecto-final/tests`) pasa el 100%.

## 7. Rúbrica

| Bloque | Peso | Excelente (4) | Suficiente (2) | Insuficiente (0) |
|---|---|---|---|---|
| Persistencia (`Almacenamiento`) | 20% | JSON íntegro, tolera archivo ausente/corrupto, ids incrementales | Funciona con datos "limpios", falla con archivo corrupto | No persiste o pierde datos |
| Validaciones (`Validador`) | 15% | Todas las reglas con `ValidacionException` y mensajes claros | Cubre las reglas básicas | No valida |
| Dominio (`Blog`) | 25% | CRUD completo, borrador/publicado, comentarios atómicos al eliminar, búsqueda | CRUD básico sin casos límite | Operaciones incompletas |
| Autenticación (`Auth` + `Sesion`) | 20% | `password_hash`/`password_verify`, sesión inyectable, roles correctos | Login/logout funcionan, sin roles | Claves en texto plano o sin sesión |
| Enrutador + front controller | 15% | MVC limpio, códigos HTTP correctos, `/admin` protegido | Enruta pero sin protección de rutas | Sin front controller |
| Tests (`tests/ejecutar.php`) | 5% | Pasan el 100% de las comprobaciones | Pasan parcialmente | No se pueden ejecutar |

> Se considera el proyecto **aprobado** con 60 puntos o más y los AC-30 (tests) cumplido.

## 8. Cómo probar

```bash
cd proyecto-final/tests
php ejecutar.php        # exit 0 + "OK: el proyecto final supera las N comprobaciones."
```

Para ver la web:

```bash
cd proyecto-final/starter
php -S localhost:8000 -t public
```

## 9. Consejos

- Implementa en este orden: `Almacenamiento` → `Validador` → `Blog` → `Sesion` → `Auth` → `Enrutador` → `public/index.php` → vistas → tests.
- Usa `throw new ValidacionException(...)` para los errores de negocio y captúralos solo en el front controller.
- No uses `mysql_*`, `eval` ni funciones obsoletas; mantén `declare(strict_types=1)` en todos los archivos.
- El autoload busca `app/<NombreClase>.php`: una clase por archivo, con el nombre exacto.
- Si la suite falla, ejecútala y corrige de uno en uno los mensajes de error que imprime.