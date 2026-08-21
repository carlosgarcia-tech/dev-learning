# Ejercicio 03 — Indices de Texto

- **Nivel:** 4/5
- **Tema:** índices de texto, $text, $search, $meta textScore, frases y exclusión
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.articulos.insertMany([
  { titulo: "Introducción a MongoDB", contenido: "MongoDB es una base de datos NoSQL. Aprende los fundamentos de mongo y su shell." },
  { titulo: "Búsqueda de texto en MongoDB", contenido: "Los índices de texto permiten buscar palabras mongo clave en documentos de texto." },
  { titulo: "Índices y rendimiento", contenido: "Un buen índice acelera las consultas y reduce el tiempo de búsqueda en grandes colecciones." },
  { titulo: "MongoDB con Node.js", contenido: "Combina MongoDB con Node.js y express para construir aplicaciones web. Una base de datos mongo bien indexada es rápida." },
  { titulo: "Geolocalización espacial", contenido: "MongoDB incluye consultas geoespaciales con índices 2dsphere para buscar puntos cercanos." }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Crea un índice de texto compuesto sobre `titulo` y `contenido` e imprime su nombre.
2. Busca con `$text $search: "mongo"` mostrando `titulo` y el `score` (`$meta: "textScore"`), ordenado por score de mayor a menor.
3. Busca la frase exacta `"base de datos"` (entre comillas en el `$search`).
4. Busca `"mongo"` excluyendo los documentos que contengan `shell` (usa `-` delante de la palabra).

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-03-indices-texto-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para un índice de texto compuesto usa `{ titulo: "text", contenido: "text" }`.
- El score se proyecta con `score: { $meta: "textScore" }` y se ordena también con `{ $meta: "textScore" }`; añade `titulo: 1` como desempate para un orden estable.
- Una frase exacta se entrecomilla dentro de `$search`: `"\"base de datos\""`.
- Para excluir un término usa el prefijo `-` (ej. `"mongo -shell"`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Índice de texto compuesto sobre titulo y contenido
print(db.articulos.createIndex({ titulo: "text", contenido: "text" }));

// 2. $text $search "mongo": score ($meta textScore), orden por score desc
db.articulos.find(
  { $text: { $search: "mongo" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" }, titulo: 1 }).forEach(d => printjson(d));

// 3. Búsqueda de frase exacta entre comillas
db.articulos.find(
  { $text: { $search: "\"base de datos\"" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Búsqueda con exclusión (palabra con "-")
db.articulos.find(
  { $text: { $search: "mongo -shell" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-indices-texto-test.sh   # requiere podman (levanta mongo efímero)
```