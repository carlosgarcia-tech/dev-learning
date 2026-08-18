# Ejercicio 06 — Objetos básicos

- **Nivel:** 1/5
- **Tema:** Objeto literal, acceder/modificar propiedades
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `objetos.js` que:

1. Cree un objeto `pelicula` con las propiedades `titulo`, `anio`, `director` y `duracionMin` (número).
2. Imprima el `titulo` con notación de punto y el `anio` con notación de corchetes.
3. Modifique `duracionMin` a un valor nuevo e imprima el objeto completo.
4. Añada la propiedad `genero` y la propiedad `premios` como un array.
5. Imprima la cantidad de premios usando `.length`.

Salida esperada (ejemplo):

```
Título: El Padrino
Año: 1972
Nueva duración: 195
{ titulo: 'El Padrino', anio: 1972, director: 'Coppola', duracionMin: 195, genero: 'Drama', premios: [ 'Oscar', 'Globo de Oro' ] }
Premios ganados: 2
```

## Requisitos

- [ ] Crear un objeto literal con al menos 4 propiedades.
- [ ] Acceder con `.propiedad` y con `["propiedad"]`.
- [ ] Modificar una propiedad existente y añadir nuevas.
- [ ] Incluir un array dentro del objeto.
- [ ] Ejecutarlo localmente con `node objetos.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-06-objetos-basicos.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Objeto literal: `const pelicula = { titulo: "...", anio: 1972 }`.
- Añadir propiedad: `pelicula.genero = "Drama";` o `pelicula["genero"] = "Drama";`.
- Un array como valor: `premios: ["Oscar"]`.
- Para ver el objeto completo usa `console.log(pelicula)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function crearPelicula() {
  return {
    titulo: "El Padrino",
    anio: 1972,
    director: "Coppola",
    duracionMin: 175,
  };
}

function enriquecer(pelicula) {
  pelicula.duracionMin = 195;
  pelicula.genero = "Drama";
  pelicula.premios = ["Oscar", "Globo de Oro"];
  return pelicula;
}

if (require.main === module) {
  const pelicula = crearPelicula();
  console.log(`Título: ${pelicula.titulo}`);
  console.log(`Año: ${pelicula["anio"]}`);
  enriquecer(pelicula);
  console.log(`Nueva duración: ${pelicula.duracionMin}`);
  console.log(pelicula);
  console.log(`Premios ganados: ${pelicula.premios.length}`);
}

module.exports = { crearPelicula, enriquecer };
````

</details>