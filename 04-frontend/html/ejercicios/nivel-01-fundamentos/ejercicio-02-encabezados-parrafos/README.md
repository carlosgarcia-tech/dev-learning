# Ejercicio 02 — Encabezados y párrafos con jerarquía

## Enunciado

Crea un `index.html` con un documento que tenga un único `<h1>`, dos secciones con `<h2>` y dentro de cada una al menos un `<h3>`. Cada sección debe contener párrafos y usar `<strong>` y `<em>`.

## Requisitos

- Exactamente un `<h1>` con tu nombre.
- Dos `<h2>` ("Experiencia" e "Idiomas").
- Al menos un `<h3>` dentro de cada `<h2>`.
- Al menos dos `<p>` con texto.
- Uso de `<strong>` y `<em>` en algún párrafo.
- Un salto de línea `<br>` y un separador `<hr>`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- No saltes niveles de encabezado: de `h1` a `h2` y de `h2` a `h3`.
- `<strong>` da importancia (negrita semántica), `<em>` da énfasis (cursiva semántica).
- `<hr>` sirve para separar secciones temáticamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CV de Ada</title>
</head>
<body>
  <h1>Ada Lovelace</h1>

  <h2>Experiencia</h2>
  <p>Trabajé con <strong>Charles Babbage</strong> en la máquina analítica.</p>
  <h3>Proyectos destacados</h3>
  <p>Esribí el <em>primer algoritmo</em> de la historia.<br>1843, Londres.</p>

  <hr>

  <h2>Idiomas</h2>
  <h3>Niveles</h3>
  <p><strong>Inglés</strong> nativo, <em>francés</em> intermedio.</p>
</body>
</html>
```

</details>
