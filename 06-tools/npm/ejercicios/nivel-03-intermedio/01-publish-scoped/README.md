# 01 — Publicar paquete scoped

## Enunciado

Prepara un paquete scoped para publicar en npm.

## Requisitos

1. En `solucion/package.json`, define el `name` como `@tuusuario/mipaquete`.
2. Configura `publishConfig.access` como `"public"`.
3. Verifica que el nombre contenga un scope (`@`).

## Pistas

- Los paquetes scoped empiezan por `@scope/`.
- Sin cuenta Pro, los scoped deben ser `access: public`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "name": "@tuusuario/mipaquete",
  "version": "1.0.0",
  "publishConfig": { "access": "public" }
}
```

</details>
