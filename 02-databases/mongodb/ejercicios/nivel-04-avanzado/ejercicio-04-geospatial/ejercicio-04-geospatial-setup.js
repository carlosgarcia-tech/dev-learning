db.locales.drop();
db.locales.insertMany([
  { nombre: "Plaza Mayor", location: { type: "Point", coordinates: [-3.707, 40.415] } },
  { nombre: "Parque del Retiro", location: { type: "Point", coordinates: [-3.683, 40.413] } },
  { nombre: "Estación de Atocha", location: { type: "Point", coordinates: [-3.690, 40.406] } },
  { nombre: "Estadio Bernabéu", location: { type: "Point", coordinates: [-3.688, 40.453] } },
  { nombre: "Puerta del Sol", location: { type: "Point", coordinates: [-3.703, 40.417] } }
]);