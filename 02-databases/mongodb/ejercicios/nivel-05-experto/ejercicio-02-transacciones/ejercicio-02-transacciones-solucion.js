// 1. Transferencia de 100 entre cuentas con transacción y commit
const session = db.getMongo().startSession();
session.startTransaction();
const cuentasTx = session.getDatabase("ejercicios_db").cuentas;
cuentasTx.updateOne({ numero: "A001" }, { $inc: { saldo: -100 } });
cuentasTx.updateOne({ numero: "A002" }, { $inc: { saldo: 100 } });
session.commitTransaction();
print("transferencia confirmada");

// 2. Verificar saldos finales (_id:0, orden estable)
db.cuentas.find({}, { _id: 0, numero: 1, saldo: 1 }).sort({ numero: 1 }).forEach(d => printjson(d));

// 3. Transacción que aborta: saldo insuficiente simulado con validación
const session2 = db.getMongo().startSession();
try {
  session2.startTransaction();
  const cuentasAbort = session2.getDatabase("ejercicios_db").cuentas;
  const origen = cuentasAbort.findOne({ numero: "A002" });
  if (origen.saldo < 500) {
    throw new Error("saldo insuficiente");
  }
  cuentasAbort.updateOne({ numero: "A002" }, { $inc: { saldo: -500 } });
  session2.commitTransaction();
} catch (e) {
  session2.abortTransaction();
}
print("transaccion abortada");

// 4. Saldos sin cambios tras el abort (_id:0, orden estable)
db.cuentas.find({}, { _id: 0, numero: 1, saldo: 1 }).sort({ numero: 1 }).forEach(d => printjson(d));
