# Ejercicio 02 — Sass/SCSS: variables y anidamiento

## Enunciado

Crea un `style.scss` que use variables, anidamiento y el operador `&` para generar CSS con BEM.

## Requisitos

- Un archivo `style.scss`.
- Al menos 2 variables (`$color`, `$espaciado`).
- Anidamiento con `&` (`.tarjeta { &__titulo { } }`).
- Un `&:hover`.
- Un mixin o un `@import` (opcional, pero las variables y anidamiento son obligatorios).
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `&__titulo` genera `.tarjeta__titulo`.
- `&:hover` genera `.tarjeta:hover`.
- Las variables en SCSS usan `$`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**style.scss**:
```scss
$color-primario: #3b82f6;
$espaciado: 16px;

.tarjeta {
  border: 1px solid #ddd;
  padding: $espaciado;
  border-radius: 8px;

  &__titulo {
    font-size: 1.2rem;
    color: $color-primario;
  }

  &__boton {
    background: $color-primario;
    color: white;
    border: none;
    padding: $espaciado;

    &:hover {
      background: darken($color-primario, 10%);
    }
  }

  &--destacada {
    border-color: $color-primario;
    border-width: 2px;
  }
}
```

</details>
