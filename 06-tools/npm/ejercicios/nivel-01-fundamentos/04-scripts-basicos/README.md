# 04 — Scripts básicos

## Enunciado

Crea scripts personalizados en `package.json`.

## Requisitos

1. Define un script `dev` que ejecute `node --watch index.js`.
2. Define un script `saludar` que ejecute `node -e "console.log('Hola desde script')"`.
3. Ejecuta `npm run saludar` y verifica que imprime el mensaje.

## Pistas

- Los scripts viven en `package.json > scripts`.
- Se ejecutan con `npm run <nombre>`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "scripts": {
    "dev": "node --watch index.js",
    "saludar": "node -e \"console.log('Hola desde script')\""
  }
}
```

</details>
