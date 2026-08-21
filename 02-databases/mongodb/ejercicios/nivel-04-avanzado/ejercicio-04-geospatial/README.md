# Ejercicio 04 — Geospatial

- **Nivel:** 4/5
- **Tema:** `2dsphere`, `$geoNear`, `$geoWithin`, `$box`, `$centerSphere`, GeoJSON
- **Tiempo estimado:** 25 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.locales.insertMany([
  { nombre: "Plaza Mayor", location: { type: "Point", coordinates: [-3.707, 40.415] } },
  { nombre: "Parque del Retiro", location: { type: "Point", coordinates: [-3.683, 40.413] } },
  { nombre: "Estación de Atocha", location: { type: "Point", coordinates: [-3.690, 40.406] } },
  { nombre: "Estadio Bernabéu", location: { type: "Point", coordinates: [-3.688, 40.453] } },
  { nombre: "Puerta del Sol", location: { type: "Point", coordinates: [-3.703, 40.417] } }
]);
```

Todos los puntos usan GeoJSON (objeto `Point` con `coordinates: [lng, lat]`, en ese orden). Responde con `mongosh` contra la base `ejercicios_db`:

1. Crea un índice `2dsphere` sobre `location` e imprime su nombre.
2. Con `$geoNear` en un pipeline de agregación, calcula la distancia desde la Puerta del Sol (`[-3.703, 40.417]`), muestra `nombre` y `dist` (redondeada a metros), ordenado de menor a mayor distancia.
3. Busca con `$geoWithin` y `$box` los locales dentro del rectángulo `[[-3.72, 40.40], [-3.68, 40.43]]`.
4. Busca con `$geoWithin` y `$centerSphere` los locales en un radio de ~3 km desde la Puerta del Sol (radio en radianes ≈ `0.0005`).

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El orden correcto de las coordenadas es `[longitud, latitud]`.
- `$geoNear` va como primera etapa del pipeline y necesita el campo `distanceField`; con `spherical: true` la distancia se devuelve en metros.
- `$box` recibe las esquinas inferior-izquierda y superior-derecha como pares `[lng, lat]`.
- En `$centerSphere` el radio se expresa en radianes: `km / 6371`; ~3 km ≈ `0.0005`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Índice geoespacial 2dsphere sobre location
print(db.locales.createIndex({ location: "2dsphere" }));

// 2. $geoNear: distancias desde la Puerta del Sol, ordenadas de menor a mayor
db.locales.aggregate([
  { $geoNear: {
      near: { type: "Point", coordinates: [-3.703, 40.417] },
      distanceField: "dist",
      spherical: true
  } },
  { $project: { _id: 0, nombre: 1, dist: { $round: "$dist" } } }
]).forEach(d => printjson(d));

// 3. $geoWithin con $box: rectángulo del centro de Madrid
printjson(db.locales.find(
  { location: { $geoWithin: { $box: [[-3.72, 40.40], [-3.68, 40.43]] } } },
  { _id: 0, nombre: 1 }
).sort({ nombre: 1 }).toArray());

// 4. $geoWithin con $centerSphere: radio ~3 km desde la Puerta del Sol
printjson(db.locales.find(
  { location: { $geoWithin: { $centerSphere: [[-3.703, 40.417], 0.0005] } } },
  { _id: 0, nombre: 1 }
).sort({ nombre: 1 }).toArray());
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
