# 03 — Script con argumentos

## Enunciado

Crea un script que acepte argumentos pasados por `npm run`.

## Requisitos

1. Define un script `echo` que ejecute `node -e "console.log(process.argv[2])"`.
2. Configúralo para que al ejecutar `npm run echo -- "hola"` imprima `hola`.

## Pistas

- Usa `--` para separar argumentos de npm de los del script.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "scripts": {
    "echo": "node -e \"console.log(process.argv[2])\" --"
  }
}
```

Ejecución: `npm run echo -- hola`

</details>
