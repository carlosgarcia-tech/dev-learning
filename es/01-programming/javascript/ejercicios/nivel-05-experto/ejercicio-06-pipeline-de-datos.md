# Ejercicio 06 — Pipeline de datos

- **Nivel:** 5/5
- **Tema:** Transformar datos en varias etapas
- **Tiempo estimado:** 40 min

## Enunciado

Crea un archivo `pipeline.js` que procese datos en **etapas encadenadas**. Dado el siguiente dataset de ventas:

```javascript
const ventas = [
  { region: "Norte", vendedor: "Ana", monto: 1200, fecha: "2026-01-15" },
  { region: "Sur", vendedor: "Luis", monto: 800, fecha: "2026-01-16" },
  { region: "Norte", vendedor: "Ana", monto: 500, fecha: "2026-02-02" },
  { region: "Sur", vendedor: "Luis", monto: 1500, fecha: "2026-02-10" },
  { region: "Norte", vendedor: "Pedro", monto: 900, fecha: "2026-02-15" },
  { region: "Sur", vendedor: "Ana", monto: 300, fecha: "2026-03-05" },
];
```

Construye un pipeline donde cada etapa sea una función que recibe los datos y devuelve los datos transformados:

1. **Filtrar** solo las ventas del mes de **febrero** (fecha que empiece por `"2026-02"`).
2. **Proyectar** (map): quedarse solo con `region`, `vendedor` y `monto`.
3. **Agrupar** por vendedor: construir un objeto `{ vendedor: total }` con `reduce`.
4. **Ordenar** los vendedores por total de mayor a menor.
5. **Formatear** cada entrada como `"Ana: 500"` y devolver un array de strings.

Además, crea una función genérica `pipeline(etapas, datosIniciales)` que encadene las etapas con `reduce` y aplique el pipeline completo.

Salida esperada:

```
Luis: 1500
Ana: 500
Pedro: 900
```

Nota: el orden del ejemplo es solo ilustrativo; la salida correcta depende del sort. En febrero: Ana vende 500, Luis 1500 y Pedro 900.

## Requisitos

- [ ] Implementar al menos 5 etapas (filtrar, proyectar, agrupar, ordenar, formatear).
- [ ] Crear la función `pipeline(etapas, datos)` que encadene etapas con `reduce`.
- [ ] Cada etapa es una función pura que recibe y devuelve datos.
- [ ] Ejecutarlo localmente con `node pipeline.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-06-pipeline-de-datos.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Filtrar por mes: `v.fecha.startsWith("2026-02")`.
- Agrupar con reduce: `acc[v.vendedor] = (acc[v.vendedor] || 0) + v.monto`.
- Ordenar un objeto: `Object.entries(obj).sort((a, b) => b[1] - a[1])`.
- `pipeline(etapas, datos)` → `etapas.reduce((datosActuales, etapa) => etapa(datosActuales), datos)`.
- Formatear: `Object.entries(objeto).map(([k, v]) => `${k}: ${v}`)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const VENTAS = [
  { region: "Norte", vendedor: "Ana", monto: 1200, fecha: "2026-01-15" },
  { region: "Sur", vendedor: "Luis", monto: 800, fecha: "2026-01-16" },
  { region: "Norte", vendedor: "Ana", monto: 500, fecha: "2026-02-02" },
  { region: "Sur", vendedor: "Luis", monto: 1500, fecha: "2026-02-10" },
  { region: "Norte", vendedor: "Pedro", monto: 900, fecha: "2026-02-15" },
  { region: "Sur", vendedor: "Ana", monto: 300, fecha: "2026-03-05" },
];

function soloFebrero(datos) {
  return datos.filter((v) => v.fecha.startsWith("2026-02"));
}

function proyectar(datos) {
  return datos.map(({ region, vendedor, monto }) => ({ region, vendedor, monto }));
}

function agruparPorVendedor(datos) {
  return datos.reduce((acc, v) => {
    acc[v.vendedor] = (acc[v.vendedor] || 0) + v.monto;
    return acc;
  }, {});
}

function ordenarPorTotal(agrupado) {
  return Object.entries(agrupado).sort((a, b) => b[1] - a[1]);
}

function formatear(entradas) {
  return entradas.map(([vendedor, total]) => `${vendedor}: ${total}`);
}

function pipeline(etapas, datosIniciales) {
  return etapas.reduce((datos, etapa) => etapa(datos), datosIniciales);
}

if (require.main === module) {
  const resultado = pipeline(
    [soloFebrero, proyectar, agruparPorVendedor, ordenarPorTotal, formatear],
    VENTAS
  );
  for (const linea of resultado) {
    console.log(linea);
  }
}

module.exports = {
  VENTAS,
  soloFebrero,
  proyectar,
  agruparPorVendedor,
  ordenarPorTotal,
  formatear,
  pipeline,
};
````

</details>