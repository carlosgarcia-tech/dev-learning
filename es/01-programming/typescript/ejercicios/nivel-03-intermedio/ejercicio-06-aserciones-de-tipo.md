# Ejercicio 06 — Aserciones de tipo

- **Nivel:** 3/5
- **Tema:** `as`, `as const`, `satisfies`, `unknown`, guardas + aserción
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `aserciones.ts` que:

1. Defina `interface Usuario { id: number; nombre: string }`.
2. Declare `const datos: unknown = JSON.parse('{"id":1,"nombre":"Ana"}')` y, tras validar con una guard type, lo convierta a `Usuario` con `as`.
3. Escriba la guard type `esUsuario(valor: unknown): valor is Usuario`.
4. Declare un objeto `config` con `as const` y compruebe que sus propiedades son literales de solo lectura.
5. Use `satisfies` para validar que un objeto `roles` cumple `Record<string, "admin" | "editor" | "lector">` **sin** perder el tipo literal inferido.
6. Intente (en comentario) un `as` directo a un tipo incompatible y explique por qué es peligroso.

Salida esperada (ejemplo):

```
Usuario validado: Ana (id 1)
config.baseUrl es "https://api.example.com"
config.version es 2
roles.ana es "admin" (literal conservado)
```

## Requisitos

- [ ] Usar `unknown` + guard type + `as` para deserializar de forma segura.
- [ ] Usar `as const` en un objeto y comprobar que el tipo es literal.
- [ ] Usar `satisfies` y verificar que el tipo literal se conserva.
- [ ] Incluir en comentario un ejemplo de aserción peligrosa.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist aserciones.ts` y luego `node dist/aserciones.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `as const` convierte las propiedades a literales `readonly`: `config.baseUrl` será `"https://api.example.com"`.
- `satisfies Record<string, ...>` valida el tipo pero conserva el tipo más específico inferido.
- La guard type evita que `as Usuario` se haga a ciegas sobre `unknown`.
- Aserción peligrosa de ejemplo: `// const invalida = datos as number; // compila pero es mentira en runtime`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist aserciones.ts && node dist/aserciones.js
interface Usuario {
  id: number;
  nombre: string;
}

function esUsuario(valor: unknown): valor is Usuario {
  if (typeof valor !== "object" || valor === null) return false;
  const v = valor as Record<string, unknown>;
  return typeof v.id === "number" && typeof v.nombre === "string";
}

const datos: unknown = JSON.parse('{"id": 1, "nombre": "Ana"}');
const usuario: Usuario = esUsuario(datos) ? (datos as Usuario) : { id: 0, nombre: "invalido" };

const config = {
  baseUrl: "https://api.example.com",
  version: 2,
} as const;

const roles = {
  ana: "admin",
  luis: "editor",
  marta: "lector",
} satisfies Record<string, "admin" | "editor" | "lector">;

// Aserción peligrosa (compila, pero en runtime no es un number):
// const falsoNumero = datos as number;

console.log(`Usuario validado: ${usuario.nombre} (id ${usuario.id})`);
console.log(`config.baseUrl es "${config.baseUrl}"`);
console.log(`config.version es ${config.version}`);
console.log(`roles.ana es "${roles.ana}" (literal conservado)`);
````

</details>