# Ejercicio 05 — Narrowing

- **Nivel:** 3/5
- **Tema:** `typeof`, `in`, `instanceof`, guardas de tipo, uniones discriminadas
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `narrowing.ts` que:

1. Defina dos interfaces: `Perro { tipo: "perro"; ladra: boolean }` y `Gato { tipo: "gato"; vidas: number }`.
2. Defina `type Mascota = Perro | Gato`.
3. Escriba `sonido(m: Mascota): string` usando el **discriminante** `tipo` con un `switch`.
4. Escriba `esPar(valor: number | string): boolean` usando `typeof`.
5. Escriba una **guard type** `esGato(m: Mascota): m is Gato` que compruebe `m.tipo === "gato"`, y úsela en `esGato` para acceder a `vidas`.
6. Escriba `tieneLlaves(obj: object, clave: string): boolean` usando el operador `in`.
7. Imprima resultados de cada caso.

Salida esperada (ejemplo):

```
Perro: guau
Gato: miau
Perro: guau (vía esGato false)
Gato: vidas 9
esPar("4"): false
esPar(4): true
Tiene clave nombre: true
```

## Requisitos

- [ ] Usar uniones discriminadas con propiedad `tipo` y `switch`.
- [ ] Usar narrowing con `typeof` y con `in`.
- [ ] Escribir una guard type con predicado `valor is Tipo`.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist narrowing.ts` y luego `node dist/narrowing.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Discriminante: las interfaces comparten `tipo` con literales distintos.
- Guard type: `function esGato(m: Mascota): m is Gato { return m.tipo === "gato"; }`.
- `in`: `"clave" in obj` es una comprobación válida de existencia.
- `esPar` con `typeof`: `typeof valor === "number"` → trata como número; sino como string (por ejemplo, `parseInt`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist narrowing.ts && node dist/narrowing.js
interface Perro {
  tipo: "perro";
  ladra: boolean;
}

interface Gato {
  tipo: "gato";
  vidas: number;
}

type Mascota = Perro | Gato;

function sonido(m: Mascota): string {
  switch (m.tipo) {
    case "perro":
      return "guau";
    case "gato":
      return "miau";
  }
}

function esGato(m: Mascota): m is Gato {
  return m.tipo === "gato";
}

function infoGato(m: Mascota): string {
  if (esGato(m)) {
    return `Gato: vidas ${m.vidas}`;
  }
  return "Perro: (no es gato)";
}

function esPar(valor: number | string): boolean {
  if (typeof valor === "number") {
    return valor % 2 === 0;
  }
  return parseInt(valor, 10) % 2 === 0;
}

function tieneLlaves(obj: object, clave: string): boolean {
  return clave in obj;
}

const toby: Mascota = { tipo: "perro", ladra: true };
const mishi: Mascota = { tipo: "gato", vidas: 9 };

console.log(`Perro: ${sonido(toby)}`);
console.log(`Gato: ${sonido(mishi)}`);
console.log(`Perro: ${infoGato(toby)}`);
console.log(infoGato(mishi));
console.log(`esPar("4"): ${esPar("4")}`);
console.log(`esPar(4): ${esPar(4)}`);
console.log(`Tiene clave nombre: ${tieneLlaves({ nombre: "Ana" }, "nombre")}`);
````

</details>