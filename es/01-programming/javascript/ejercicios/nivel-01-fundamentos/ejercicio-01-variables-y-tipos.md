# Ejercicio 01 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** let/const, typeof, template literals
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `variables.js` que:

1. Declare con `const` tu nombre y tu ciudad de nacimiento.
2. Declare con `let` tu edad (número) y un booleano que indique si estudias programación.
3. Usando `typeof`, imprima el tipo de cada variable con `console.log`.
4. Imprima una frase final con **template literals** que diga: `Soy <nombre>, tengo <edad> años, nací en <ciudad> y es <true|false> que estudio programación.`

Salida esperada (ejemplo):

```
nombre es de tipo string
ciudad es de tipo string
edad es de tipo number
programacion es de tipo boolean
Soy Ana, tengo 30 años, nací en Lima y es true que estudio programación.
```

## Requisitos

- [ ] Usar `const` para los datos que no cambian y `let` para la edad.
- [ ] Imprimir los 4 tipos con `typeof`.
- [ ] La frase final usa template literals con `${}`.
- [ ] Ejecutarlo localmente con `node variables.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Recuerda la sintaxis: `const nombre = "Ana";` y `let edad = 30;`.
- `typeof` se usa así: `typeof nombre` y devuelve un string.
- Dentro de los backticks puedes escribir texto y `${variable}`.
- No uses `var`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const nombre = "Ana";
const ciudad = "Lima";
let edad = 30;
const programacion = true;

console.log(`nombre es de tipo ${typeof nombre}`);
console.log(`ciudad es de tipo ${typeof ciudad}`);
console.log(`edad es de tipo ${typeof edad}`);
console.log(`programacion es de tipo ${typeof programacion}`);

console.log(
  `Soy ${nombre}, tengo ${edad} años, nací en ${ciudad} y es ${programacion} que estudio programación.`
);
````

</details>