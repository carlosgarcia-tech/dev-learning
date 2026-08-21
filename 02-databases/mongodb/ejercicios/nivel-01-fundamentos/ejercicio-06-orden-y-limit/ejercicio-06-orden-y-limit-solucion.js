// 1. Jugadores ordenados por puntos de forma descendente
db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).forEach(d => printjson(d));

// 2. Top 3: orden descendente + limit(3)
db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).limit(3).forEach(d => printjson(d));

// 3. Paginación: skip(2) + limit(3) con orden descendente
db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).skip(2).limit(3).forEach(d => printjson(d));

// 4. El jugador con más puntos (findOne con orden)
printjson(db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).limit(1).next());