# Ejercicio 05 — Promesas

- **Nivel:** 3/5
- **Tema:** Promesas, then/catch, Promise.all
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `promesas.js` que:

1. Defina `simularDescarga(archivo, ms)` que devuelva una **promesa** que se resuelve con `"Descargado: <archivo>"` tras `ms` milisegundos.
2. Defina `dividir(a, b)` que devuelva una promesa que se resuelve con `a / b`, o se rechaza con `"No se puede dividir entre cero"` si `b === 0`.
3. Con `then/catch`, descargue `"video.mp4"` con 300 ms y encadene un segundo `.then` que imprima `"Reproduciendo <resultado>"`.
4. Con `Promise.all`, descargue tres archivos en paralelo y cuando todas terminen imprima el array de resultados.
5. Pruebe `dividir(10, 0)` con `.catch` e imprima el error.

Salida esperada:

```
Descargado: video.mp4
Reproduciendo Descargado: video.mp4
Descarga en paralelo: [ 'Descargado: a.txt', 'Descargado: b.txt', 'Descargado: c.txt' ]
Error: No se puede dividir entre cero
```

## Requisitos

- [ ] Crear promesas con `new Promise((resolve, reject) => ...)`.
- [ ] Encadenar `.then` y capturar con `.catch`.
- [ ] Usar `Promise.all` para ejecutar en paralelo.
- [ ] Ejecutarlo localmente con `node promesas.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-05-promesas.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `resolve(valor)` resuelve; `reject(razon)` rechaza.
- `Promise.all([p1, p2, p3]).then((resultados) => ...)`.
- Encadenar: `.then((r) => ...).then((r2) => ...)`.
- El `.catch` captura tanto rechazos como errores lanzados dentro de un `.then`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function simularDescarga(archivo, ms) {
  return new Promise((resolve) => {
    setTimeout(() => resolve(`Descargado: ${archivo}`), ms);
  });
}

function dividir(a, b) {
  return new Promise((resolve, reject) => {
    if (b === 0) {
      reject(new Error("No se puede dividir entre cero"));
      return;
    }
    resolve(a / b);
  });
}

if (require.main === module) {
  simularDescarga("video.mp4", 300)
    .then((resultado) => {
      console.log(resultado);
      return resultado;
    })
    .then((resultado) => console.log(`Reproduciendo ${resultado}`));

  Promise.all([
    simularDescarga("a.txt", 100),
    simularDescarga("b.txt", 200),
    simularDescarga("c.txt", 150),
  ]).then((resultados) => console.log(`Descarga en paralelo: ${resultados}`));

  dividir(10, 0).catch((error) => console.log(`Error: ${error.message}`));
  dividir(10, 2).then((r) => console.log(`División válida: ${r}`));
}

module.exports = { simularDescarga, dividir };
````

</details>