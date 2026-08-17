# Ejercicio 06 — Closures

- **Nivel:** 2/5
- **Tema:** Closures, estado privado
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `closures.js` que:

1. Defina una función `crearContador()` que use un closure para mantener un contador privado y devuelva un objeto con métodos `incrementar()`, `decrementar()` y `obtener()`.
2. Cree dos contadores independientes (`contadorA` y `contadorB`) y compruebe que cada uno mantiene su propio estado.
3. Defina `crearMultiplicador(n)` que devuelva una función que multiplica su argumento por `n`, y cree `porDos` y `porTres`.
4. Imprima los resultados.

Salida esperada:

```
A incrementa: 1
A incrementa: 2
B incrementa: 1
A decrementa: 1
A obtener: 1
B obtener: 1
porDos(5): 10
porTres(5): 15
```

## Requisitos

- [ ] Implementar `crearContador` con una variable privada capturada por closure.
- [ ] Crear al menos 2 contadores independientes.
- [ ] Implementar `crearMultiplicador` con closure.
- [ ] Ejecutarlo localmente con `node closures.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La variable `cuenta` se declara fuera de las funciones internas pero dentro de `crearContador`.
- Cada llamada a `crearContador()` crea un **nuevo** entorno con su propia `cuenta`.
- Un closure "recuerda" las variables del ámbito donde fue creado.
- El multiplicador: `return (x) => x * n;`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function crearContador() {
  let cuenta = 0;
  return {
    incrementar() {
      cuenta++;
      return cuenta;
    },
    decrementar() {
      cuenta--;
      return cuenta;
    },
    obtener() {
      return cuenta;
    },
  };
}

const contadorA = crearContador();
const contadorB = crearContador();

console.log(`A incrementa: ${contadorA.incrementar()}`);
console.log(`A incrementa: ${contadorA.incrementar()}`);
console.log(`B incrementa: ${contadorB.incrementar()}`);
console.log(`A decrementa: ${contadorA.decrementar()}`);
console.log(`A obtener: ${contadorA.obtener()}`);
console.log(`B obtener: ${contadorB.obtener()}`);

function crearMultiplicador(n) {
  return (x) => x * n;
}

const porDos = crearMultiplicador(2);
const porTres = crearMultiplicador(3);
console.log(`porDos(5): ${porDos(5)}`);
console.log(`porTres(5): ${porTres(5)}`);
````

</details>