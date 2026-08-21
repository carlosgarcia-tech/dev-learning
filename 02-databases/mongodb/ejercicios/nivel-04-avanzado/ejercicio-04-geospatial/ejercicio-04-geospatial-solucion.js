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