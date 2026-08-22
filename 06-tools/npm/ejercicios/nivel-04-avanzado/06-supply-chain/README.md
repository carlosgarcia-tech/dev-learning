# 06 — Supply chain

## Enunciado

Explica el ataque de dependency confusion y cómo prevenirlo.

## Requisitos

1. Crea `solucion/respuesta.txt`.
2. Explica qué es dependency confusion.
3. Menciona al menos una forma de prevenirlo.

## Pistas

- Ocurre cuando un paquete privado se confunde con uno público del mismo nombre.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Dependency confusion: un atacante publica en el registry público un paquete con el mismo nombre que uno privado tuyo. Si el CI busca primero en el público, instala el malicioso.
Prevención: usar scopes (@miorg/) y configurar el registry privado para ese scope en .npmrc.
```

</details>
