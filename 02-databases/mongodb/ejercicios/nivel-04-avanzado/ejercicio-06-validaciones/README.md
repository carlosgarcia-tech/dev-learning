# Ejercicio 06 — Validaciones

- **Nivel:** 4/5
- **Tema:** `createCollection`, `$jsonSchema`, validación de documentos, `getCollectionInfos`
- **Tiempo estimado:** 25 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.clientes.drop();   // la colección no existe: la creará la solución con su validator
```

El setup solo borra la colección: la tarea es crearla con validación. Responde con `mongosh` contra la base `ejercicios_db`:

1. Crea la colección `clientes` con `createCollection` y un `validator` `$jsonSchema` que exija los campos `nombre` (string), `edad` (int, mínima 18) y `email` (string que contenga `@`).
2. Inserta un documento válido (`ana`, edad 30, `ana@mail.com`) y comprueba con un `find`. Recuerda que el tipo `int` requiere `NumberInt(...)`.
3. Intenta insertar un documento inválido (`luis`, edad 15) dentro de un `try/catch` y muestra el `code` y el `message` del error.
4. Verifica que la validación está activa con `getCollectionInfos`, mostrando solo `name` y `options.validator`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `validator` se pasa como opción de `createCollection`: `{ validator: { $jsonSchema: { bsonType: "object", required: [...], properties: {...} } } }`.
- En `mongosh` un número plano es `double`; para que valide `bsonType: "int"` usa `NumberInt(30)`.
- La validación falla con un error `MongoServerError`; el `code` 121 (DocumentValidationFailure) es determinista, aunque `codeName` no se expone en mongosh.
- `db.getCollectionInfos({ name: "clientes" })` devuelve el `validator` dentro de `options`; filtra a `{ name, options.validator }` antes de imprimir.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Colección con validación $jsonSchema
db.createCollection("clientes", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre", "edad", "email"],
      properties: {
        nombre: { bsonType: "string", description: "nombre obligatorio" },
        edad: { bsonType: "int", minimum: 18, description: "edad adulta" },
        email: { bsonType: "string", pattern: "@", description: "email con @" }
      }
    }
  }
});
print("coleccion creada con validacion");

// 2. Insert válido (edad debe ser de tipo int con NumberInt)
db.clientes.insertOne({ nombre: "ana", edad: NumberInt(30), email: "ana@mail.com" });
printjson(db.clientes.find({}, { _id: 0 }).sort({ nombre: 1 }).toArray());

// 3. Insert inválido: error capturado con try/catch
try {
  db.clientes.insertOne({ nombre: "luis", edad: NumberInt(15), email: "luis@mail.com" });
} catch (e) {
  print("code: " + e.code);
  print("message: " + e.message);
}

// 4. Verificar que la validación está activa: getCollectionInfos con options
printjson(db.getCollectionInfos({ name: "clientes" }).map(c => ({ name: c.name, validator: c.options.validator })));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
