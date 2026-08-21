// 1. Abrir watch() y capturar el evento del primer insert
const cs = db.eventos.watch();
cs.disableBlockWarnings();
db.eventos.insertOne({ tipo: "login", usuario: "ana" });
const ev1 = cs.next();
printjson({ op: ev1.operationType, usuario: ev1.fullDocument.usuario });

// 2. Insertar un segundo doc y capturar su evento
db.eventos.insertOne({ tipo: "registro", usuario: "luis" });
const ev2 = cs.next();
printjson({ op: ev2.operationType, usuario: ev2.fullDocument.usuario });

// 3. Cerrar el cursor
cs.close();
print("cursor cerrado");
