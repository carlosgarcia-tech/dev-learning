# 05 — npx

## Enunciado

Usa `npx` para ejecutar un paquete sin instalarlo globalmente.

## Requisitos

1. Ejecuta `npx cowsay "Hola npm"` (cowsay se descarga temporalmente).
2. Crea un archivo `salida.txt` con el resultado del comando.
3. Verifica que `cowsay` NO aparece en `package.json` (no se instaló permanentemente).

## Pistas

- `npx paquete args` ejecuta sin instalar globalmente.
- Redirige con `>` para guardar la salida.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npx cowsay "Hola npm" > salida.txt
cat salida.txt
# cowsay no aparece en package.json
```

</details>
