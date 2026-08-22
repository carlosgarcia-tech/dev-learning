# Ejercicio 06 — Select, textarea y fieldset

## Enunciado

Crea un `index.html` con un formulario de perfil que agrupe campos con `<fieldset>`/`<legend>`, incluya un `<select>` con `<optgroup>`, un `<textarea>` y radios y checkboxes.

## Requisitos

- Un `<fieldset>` con `<legend>`.
- Un `<select>` con al menos un `<optgroup>` y opciones dentro.
- Un `<textarea>` con `rows` y `maxlength`.
- Al menos 2 radios que compartan `name`.
- Al menos 2 checkboxes.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `<optgroup label="...">` agrupa opciones visualmente en el desplegable.
- Los radios comparten `name` para que solo uno esté seleccionado.
- `<textarea>` no es un `<input>`, el contenido va entre las etiquetas.

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
  <title>Perfil</title>
</head>
<body>
  <h1>Perfil</h1>
  <form action="/perfil" method="POST">
    <fieldset>
      <legend>Datos personales</legend>

      <label for="pais">País</label>
      <select id="pais" name="pais">
        <optgroup label="Europa">
          <option value="es">España</option>
          <option value="fr">Francia</option>
        </optgroup>
        <optgroup label="América">
          <option value="mx">México</option>
          <option value="ar">Argentina</option>
        </optgroup>
      </select>

      <label for="bio">Biografía</label>
      <textarea id="bio" name="bio" rows="4" maxlength="500"></textarea>
    </fieldset>

    <fieldset>
      <legend>Preferencias</legend>
      <p>Plan:</p>
      <label><input type="radio" name="plan" value="basico" checked> Básico</label>
      <label><input type="radio" name="plan" value="pro"> Pro</label>

      <p>Intereses:</p>
      <label><input type="checkbox" name="intereses" value="deportes"> Deportes</label>
      <label><input type="checkbox" name="intereses" value="musica"> Música</label>
    </fieldset>

    <button type="submit">Guardar</button>
  </form>
</body>
</html>
```

</details>
