# Ejercicio 04 — getServerSideProps (Pages Router)

## Enunciado

Crea una página del Pages Router que use `getServerSideProps` para SSR.

## Requisitos
- Un archivo `pagina.js`.
- `export async function getServerSideProps()`.
- Retorna `{ props: { ... } }`.
- `export default function Pagina({ datos })`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
export async function getServerSideProps() {
  const res = await fetch('https://api.example.com/data');
  const datos = await res.json();
  return { props: { datos } };
}

export default function Pagina({ datos }) {
  return <h1>{datos.title}</h1>;
}
```
</details>
