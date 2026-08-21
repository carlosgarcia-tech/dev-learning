# Ejercicio 02 — Transacciones

- **Nivel:** 5/5
- **Tema:** transacciones, sessions, `commitTransaction`, `abortTransaction`
- **Tiempo estimado:** 25 min
- **Requisito:** requiere un replica set (el `test.sh` lo detecta y, si no hay, valida la sintaxis)

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.cuentas.insertMany([
  { numero: "A001", saldo: 500 },
  { numero: "A002", saldo: 100 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Inicia una sesión, abre una transacción y transfiere 100 unidades de `A001` a `A002` (dos `updateOne` con `$inc`), confirmando con `commitTransaction`.
2. Verifica los saldos finales de ambas cuentas (proyección `_id: 0`, orden por `numero`).
3. Abre otra transacción que intente retirar 500 de `A002` pero con validación de saldo insuficiente; aborta con `abortTransaction`.
4. Verifica que tras el abort los saldos no cambiaron.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una transacción necesita una sesión: `const session = db.getMongo().startSession()` y después `session.startTransaction()`.
- Dentro de la transacción usa la base de la sesión: `session.getDatabase("ejercicios_db").cuentas` (las lecturas/escrituras deben pasar por la sesión).
- La "validación de saldo insuficiente" es manual: lee el saldo dentro de la transacción y lanza un `throw new Error(...)` si no hay saldo; el `catch` hace `session.abortTransaction()`.
- Tras `commitTransaction` los cambios persisten; tras `abortTransaction` la colección queda como estaba.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
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
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
