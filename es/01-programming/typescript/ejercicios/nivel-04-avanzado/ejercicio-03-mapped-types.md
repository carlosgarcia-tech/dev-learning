# Ejercicio 03 — Mapped types

- **Nivel:** 4/5
- **Tema:** `[K in keyof T]`, modificadores `+`/`-`, transformaciones de forma
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `mapped-types.ts` que:

1. Defina `interface Config` con `host: string`, `puerto: number` y `seguro: boolean`.
2. Defina `type Opcional = { [K in keyof Config]?: Config[K] }`.
3. Defina `type SoloLectura = { readonly [K in keyof Config]: Config[K] }`.
4. Defina `type Descriptores = { [K in keyof Config]: { valor: Config[K]; descripcion: string } }`.
5. Defina `type Valores = { [K in keyof Config]: boolean }`.
6. Escriba una función `configDescripcion(c: Config): Descriptores` y compruebe con un objeto real que `Opcional`, `SoloLectura` y `Valores` se comportan como se espera (con comentarios de los errores).

Salida esperada (ejemplo):

```
Opcional compila: { host: localhost }
SoloLectura compila: localhost:8080 seguro: true
Descriptores: host -> valor localhost, descripcion Servidor
Valores: { host: true, puerto: true, seguro: true }
```

## Requisitos

- [ ] Definir al menos 4 mapped types con `[K in keyof T]`.
- [ ] Usar el modificador `?` y `readonly` en al menos uno.
- [ ] Transformar el valor de cada clave en uno de los mapped types.
- [ ] Intentar (en comentario) reasignar una propiedad `readonly`.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist mapped-types.ts` y luego `node dist/mapped-types.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sintaxis base: `{ [K in keyof Config]: Config[K] }`.
- Para quitar modificadores se usa `-readonly` o `-?` (no hace falta aquí).
- `Descriptors` transforma cada valor en un objeto con `valor` y `descripcion`.
- `Valores` mapea cada clave a `boolean`.
- La reasignación de una propiedad `readonly` va en comentario: `// soloLectura.puerto = 9999; // ERROR`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist mapped-types.ts && node dist/mapped-types.js
interface Config {
  host: string;
  puerto: number;
  seguro: boolean;
}

type Opcional = { [K in keyof Config]?: Config[K] };
type SoloLectura = { readonly [K in keyof Config]: Config[K] };
type Descriptores = { [K in keyof Config]: { valor: Config[K]; descripcion: string } };
type Valores = { [K in keyof Config]: boolean };

const cfg: Config = { host: "localhost", puerto: 8080, seguro: true };

const opcional: Opcional = { host: "localhost" };
const soloLectura: SoloLectura = cfg;
// soloLectura.puerto = 9999; // ERROR: readonly

function configDescripcion(c: Config): Descriptores {
  const descripcionDe = {
    host: "Servidor",
    puerto: "Puerto",
    seguro: "Usa TLS",
  } satisfies Record<keyof Config, string>;

  return {
    host: { valor: c.host, descripcion: descripcionDe.host },
    puerto: { valor: c.puerto, descripcion: descripcionDe.puerto },
    seguro: { valor: c.seguro, descripcion: descripcionDe.seguro },
  };
}

const valores: Valores = { host: true, puerto: true, seguro: true };
const descriptores = configDescripcion(cfg);

console.log(`Opcional compila: ${JSON.stringify(opcional)}`);
console.log(`SoloLectura compila: ${soloLectura.host}:${soloLectura.puerto} seguro: ${soloLectura.seguro}`);
console.log(`Descriptores: host -> valor ${descriptores.host.valor}, descripcion ${descriptores.host.descripcion}`);
console.log(`Valores: ${JSON.stringify(valores)}`);
````

</details>