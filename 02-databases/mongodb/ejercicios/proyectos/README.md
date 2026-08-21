# Proyecto Final — Blog NoSQL con MongoDB

> Proyecto integrador que aplica todo lo aprendido del tema MongoDB: CRUD, agregaciones, índices, validación de esquemas y change streams.

- **Nivel:** Integrador (5/5)
- **Tiempo estimado:** 2-4 horas
- **Base de datos:** `blog_db`

## Contexto

Vas a modelar y construir el backend de datos de un **blog** con MongoDB. El blog gestiona:

- **Usuarios**: autores que publican posts.
- **Posts**: artículos con título, contenido, autor, tags y categoría.
- **Comentarios**: comentarios embebidos en cada post (modelo embebido).
- **Tags**: etiquetas para clasificar posts.
- **Categorías**: colección de referencia para clasificar posts.

El proyecto cubre el ciclo completo: diseño del modelo de datos, inserciones, consultas con agregación para reportes, índices para búsqueda, validación de esquemas y notificaciones en tiempo real con change streams.

## Modelo de datos

```js
// usuarios (colección con validación de esquema)
db.usuarios.insertOne({
  _id: "u1",
  nombre: "Ana García",
  email: "ana@mail.com",
  rol: "autor",
  creado: ISODate("2024-01-01T00:00:00Z")
});

// categorias (colección de referencia)
db.categorias.insertOne({ _id: "c1", nombre: "Tecnología", slug: "tecnologia" });

// posts (comentarios embebidos; categoría referenciada)
db.posts.insertOne({
  _id: "p1",
  titulo: "Introducción a MongoDB",
  contenido: "MongoDB es una base de datos de documentos...",
  autor_id: "u1",
  categoria_id: "c1",
  tags: ["mongodb", "nosql", "base-de-datos"],
  publicado: true,
  views: 150,
  creado: ISODate("2024-01-15T10:00:00Z"),
  comentarios: [
    { usuario: "Luis", texto: "¡Muy bueno!", fecha: ISODate("2024-01-16T08:00:00Z") }
  ]
});
```

## Requisitos

- [ ] El `setup.js` crea la base `blog_db`, define validaciones e inserta datos de ejemplo.
- [ ] La `solucion.js` resuelve todas las consultas del enunciado.
- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup.
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda.
- [ ] Los tests pasan: `bash test.sh`

## Enunciado

Implementa las siguientes operaciones en `solucion.js`:

### 1. Validación de esquemas

Crea la colección `usuarios` con un `validator` `$jsonSchema` que exija:
- `nombre` (string, obligatorio)
- `email` (string con patrón `@`, obligatorio)
- `rol` (string, enum `["autor", "editor", "admin"]`, obligatorio)

### 2. CRUD básico

1. Inserta un nuevo usuario con rol `autor`.
2. Inserta un nuevo post publicado con 2 tags y 1 comentario embebido.
3. Actualiza con `updateOne` el `views` de un post sumándole 10 (`$inc`).
4. Añade un comentario nuevo a un post con `$push`.

### 3. Agregaciones para reportes

5. **Top 3 posts por visitas**: ordena por `views` descendente y limita a 3, proyectando `titulo` y `views` (`_id: 0`).
6. **Posts por autor**: usa `$lookup` para unir `posts` con `usuarios` y muestra `autor` (nombre) y `num_posts`.
7. **Posts por tag**: usa `$unwind` sobre `tags` y `$group` para contar cuántos posts tiene cada tag.
8. **Comentarios totales por post**: calcula el número de comentarios de cada post con `$size` (sin `$unwind`).

### 4. Índices para búsqueda

9. Crea un índice de texto sobre `titulo` y `contenido` de `posts`.
10. Busca con `$text $search: "mongodb"` mostrando `titulo` y `score`, ordenado por score descendente.
11. Crea un índice ascendente sobre `autor_id` para acelerar el `$lookup`.

### 5. Change streams (requiere replica set)

12. Abre un change stream sobre `posts`, inserta un post nuevo y captura el evento mostrando `operationType` y `titulo`.

## Fases sugeridas

| Fase | Qué haces | Entregable |
|---|---|---|
| 1. Modelo | Leer el enunciado y entender el modelo embebido + referenciado | Esquema mental |
| 2. Setup | Ejecutar `setup.js` y revisar los datos cargados | `mongosh blog_db` |
| 3. Validación | Implementar el `$jsonSchema` de `usuarios` | Sección 1 |
| 4. CRUD | Implementar insert/update/push | Secciones 2 |
| 5. Agregaciones | Implementar los 4 reportes | Sección 3 |
| 6. Índices | Crear índices y hacer búsquedas | Sección 4 |
| 7. Change streams | Implementar la captura de eventos (requiere replica set) | Sección 5 |
| 8. Tests | Ejecutar `bash test.sh` hasta que pase | `OK Tests pasaron` |

## Criterios de aceptación

- ✅ El `setup.js` carga los datos sin errores y define la validación de `usuarios`.
- ✅ La `solucion.js` resuelve los 12 puntos del enunciado.
- ✅ Las agregaciones usan `$lookup`, `$unwind`, `$group`, `$sort` y `$size` correctamente.
- ✅ El índice de texto se crea y la búsqueda `$text` devuelve resultados ordenados por score.
- ✅ El change stream captura el evento de inserción (en un replica set).
- ✅ `bash test.sh` imprime `OK Tests pasaron`.

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `setup.js` | Crea la base `blog_db`, define validaciones e inserta datos de ejemplo |
| `solucion.js` | Solución de referencia con las 12 operaciones |
| `test.sh` | Valida el proyecto: ejecuta setup + solución si hay `mongosh`, si no valida sintaxis |

## Cómo ejecutar

```bash
# Con servidor MongoDB disponible (mongosh)
bash test.sh

# Sin servidor: valida la sintaxis JS con node --check
bash test.sh
```

> **Nota sobre change streams:** el punto 12 requiere un replica set. El `test.sh` detecta si el servidor es replica set; si no lo es, valida la sintaxis JS. Para probarlo en local, arranca MongoDB con `--replSet rs0` e inicialízalo con `rs.initiate()`.
