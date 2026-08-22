# Ejercicio 02 — Implementar Strategy

- **Nivel:** 2/5
- **Tema:** Patrón Strategy (algoritmos intercambiables)
- **Tiempo estimado:** 30 min

## Enunciado

Tu app de logística calcula el coste de envío de un paquete según el transportista (estándar, express, internacional). En vez de un `if` por tipo, implementa **Strategy**: una familia de estrategias con una interfaz común, intercambiables en tiempo de ejecución.

El archivo `solucion.js` debe contener:

- Una clase base `EstrategiaEnvio` con método `calcular(peso, distancia)`.
- Estrategias concretas: `EnvioEstandar`, `EnvioExpress`, `EnvioInternacional`.
- Una clase `CalculadoraEnvio` que **recibe** una estrategia y puede cambiarla (`setEstrategia`).
- Cada estrategia calcula distinto (fórmulas diferentes).

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.js`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `EstrategiaEnvio` con método `calcular(peso, distancia)`
- [ ] `solucion.js` define `EnvioEstandar`, `EnvioExpress`, `EnvioInternacional`
- [ ] `solucion.js` define `CalculadoraEnvio` con `setEstrategia(e)` y `calcular(peso, distancia)`
- [ ] Cada estrategia usa una fórmula distinta (no todas iguales)
- [ ] `calcular` cambia de comportamiento al cambiar la estrategia (sin `if` por tipo)
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `EnvioEstandar`: `peso * 1 + distancia * 0.5`
- `EnvioExpress`: `peso * 2 + distancia * 1` (más caro, más rápido)
- `EnvioInternacional`: `peso * 3 + distancia * 2` (frontera, aduanas)
- `CalculadoraEnvio` guarda `this.estrategia` y en `calcular` delega: `this.estrategia.calcular(...)`.
- `setEstrategia` reemplaza `this.estrategia`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
// Interfaz común
class EstrategiaEnvio {
  calcular(peso, distancia) { throw new Error('no implementado'); }
}

// Estrategias concretas
class EnvioEstandar extends EstrategiaEnvio {
  calcular(peso, distancia) { return peso * 1 + distancia * 0.5; }
}
class EnvioExpress extends EstrategiaEnvio {
  calcular(peso, distancia) { return peso * 2 + distancia * 1; }
}
class EnvioInternacional extends EstrategiaEnvio {
  calcular(peso, distancia) { return peso * 3 + distancia * 2; }
}

// Contexto: usa la estrategia inyectada, intercambiable
class CalculadoraEnvio {
  constructor(estrategia) { this.estrategia = estrategia; }
  setEstrategia(e) { this.estrategia = e; return this; }
  calcular(peso, distancia) { return this.estrategia.calcular(peso, distancia); }
}

module.exports = {
  EstrategiaEnvio, EnvioEstandar, EnvioExpress, EnvioInternacional, CalculadoraEnvio,
};
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
