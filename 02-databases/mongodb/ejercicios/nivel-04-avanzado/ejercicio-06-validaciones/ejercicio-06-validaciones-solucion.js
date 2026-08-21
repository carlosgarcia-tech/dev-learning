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