# Ejercicio 03 — Strings

- **Nivel:** 1/5
- **Tema:** Métodos de string, length, concatenación
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `strings.js` que:

1. Tenga una variable `frase = "  JavaScript es genial  "` (con espacios al inicio y al final).
2. Imprima la longitud de `frase` con `.length`.
3. Imprima la frase sin espacios al inicio y al final con `.trim()`.
4. Imprima la frase en mayúsculas (`.toUpperCase()`) y en minúsculas (`.toLowerCase()`).
5. Compruebe con `.includes("genial")` si la frase contiene la palabra "genial" e imprima `true`.
6. Separe la frase en palabras con `.split(" ")` y concatené un string final con `+` y con template literals.

Salida esperada (ejemplo):

```
Longitud: 23
Sin espacios: "JavaScript es genial"
Mayúsculas: JAVASCRIPT ES GENIAL
Minúsculas: javascript es genial
¿Contiene "genial"? true
Palabras: [ 'JavaScript', 'es', 'genial' ]
Concatenación: Me encanta: JavaScript es genial!
Template: Aprendo "JavaScript es genial" hoy
```

## Requisitos

- [ ] Usar `.length`, `.trim()`, `.toUpperCase()`, `.toLowerCase()`, `.includes()` y `.split()`.
- [ ] Concatenar con `+` y con template literals.
- [ ] Ejecutarlo localmente con `node strings.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `"  hola  ".trim()` devuelve `"hola"` (quita espacios de los extremos, no los internos).
- `.includes("texto")` devuelve `true` o `false`.
- `.split(" ")` devuelve un array de partes separadas por espacios.
- Los strings son inmutables: los métodos devuelven un string **nuevo**, no modifican el original.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const frase = "  JavaScript es genial  ";

console.log(`Longitud: ${frase.length}`);
console.log(`Sin espacios: "${frase.trim()}"`);
console.log(`Mayúsculas: ${frase.toUpperCase()}`);
console.log(`Minúsculas: ${frase.toLowerCase()}`);
console.log(`¿Contiene "genial"? ${frase.includes("genial")}`);
console.log(`Palabras: ${frase.trim().split(" ")}`);

const limpia = frase.trim();
console.log("Concatenación: " + "Me encanta: " + limpia + "!");
console.log(`Template: Aprendo "${limpia}" hoy`);
````

</details>