# Ejercicio 06 — i18n con [lang]

## Enunciado

Crea un `page.jsx` en `app/[lang]/page.jsx` que cargue un diccionario según el idioma y muestre un texto traducido.

## Requisitos
- Un archivo `page.jsx`.
- Props `{ params }`.
- Lee `params.lang`.
- Un diccionario con al menos 2 idiomas (es, en).
- Muestra una traducción.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
const diccionarios = {
  es: { welcome: 'Bienvenido' },
  en: { welcome: 'Welcome' }
};

export default function Page({ params }) {
  const t = diccionarios[params.lang] || diccionarios.es;
  return <h1>{t.welcome}</h1>;
}
```
</details>
