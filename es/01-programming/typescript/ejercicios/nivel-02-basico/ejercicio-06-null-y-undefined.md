# Ejercicio 06 — Null y undefined

- **Nivel:** 2/5
- **Tema:** `strictNullChecks`, `null`, `undefined`, narrowing, `??`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `null-undefined.ts` que:

1. Declare una función `buscarPorId(id: number): string | null` que devuelva `null` si el id es impar y un nombre si es par (usa un array fijo de 3 nombres).
2. Declare una función `obtenerMayuscula(nombre: string | null): string` que use `??` para devolver `"DESCONOCIDO"` cuando el valor sea `null`.
3. Declare una función `longitudSegura(texto: string | undefined): number` que devuelva `0` si es `undefined` (usa narrowing con `if`).
4. Escriba un helper `buscarOAlternativa(id: number, alternativa: string): string` que combine las dos anteriores.
5. Imprima los resultados de probar los ids 0, 1 y 2, y un caso `undefined`.

Salida esperada (ejemplo):

```
Id 0 -> ANA
Id 1 -> DESCONOCIDO
Id 2 -> LUIS
Texto undefined -> longitud 0
Id 9 -> DESCONOCIDO
```

## Requisitos

- [ ] Usar `null` como retorno posible y manejarlo con `??`.
- [ ] Usar narrowing con `if` para `string | undefined`.
- [ ] Componer funciones que devuelvan tipos nullable.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist null-undefined.ts` y luego `node dist/null-undefined.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Con `strictNullChecks` activado, `string | null` no se asigna a `string` directamente.
- `??` solo se dispara con `null` o `undefined`, no con `""` ni `0`.
- Narrowing: `if (texto === undefined) return 0;` o `if (texto) ...`.
- `buscarOAlternativa` puede llamar a `obtenerMayuscula(buscarPorId(id))` pero recuerda que `buscarPorId` devuelve `string | null`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist null-undefined.ts && node dist/null-undefined.js
const nombres = ["Ana", "Luis", "Marta"];

function buscarPorId(id: number): string | null {
  if (id >= 0 && id < nombres.length) {
    return nombres[id];
  }
  return null;
}

function obtenerMayuscula(nombre: string | null): string {
  return (nombre ?? "DESCONOCIDO").toUpperCase();
}

function longitudSegura(texto: string | undefined): number {
  if (texto === undefined) {
    return 0;
  }
  return texto.length;
}

function buscarOAlternativa(id: number, alternativa: string): string {
  const encontrado = buscarPorId(id);
  return obtenerMayuscula(encontrado) || alternativa;
}

console.log(`Id 0 -> ${obtenerMayuscula(buscarPorId(0))}`);
console.log(`Id 1 -> ${obtenerMayuscula(buscarPorId(1))}`);
console.log(`Id 2 -> ${obtenerMayuscula(buscarPorId(2))}`);
console.log(`Texto undefined -> longitud ${longitudSegura(undefined)}`);
console.log(`Id 9 -> ${buscarOAlternativa(9, "ALTERNATIVA")}`);
````

</details>