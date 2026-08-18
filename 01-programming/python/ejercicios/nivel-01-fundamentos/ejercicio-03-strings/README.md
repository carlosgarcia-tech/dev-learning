# Ejercicio 03 — Strings

- **Nivel:** 1/5
- **Tema:** métodos de strings, f-strings, slicing
- **Tiempo estimado:** 15 min

## Enunciado

Completa `main.py` para que implemente funciones que procesen una frase:

1. `mayusculas(frase)` — devuelve la frase con `upper()`.
2. `minusculas(frase)` — devuelve la frase con `lower()`.
3. `titulo(frase)` — devuelve la frase con la primera letra de cada palabra en mayúscula (`title()`).
4. `n_caracteres(frase)` — devuelve `len(frase)`.
5. `n_palabras(frase)` — devuelve `len(frase.split())`.
6. `invertida(frase)` — devuelve la frase invertida (slicing con `[::-1]`).
7. `contar_a(frase)` — devuelve cuántas veces aparece la letra `a` (`count("a")`).

Salida esperada (ejemplo con `Hola mundo`):

```
mayusculas("Hola mundo") == "HOLA MUNDO"
minusculas("Hola mundo") == "hola mundo"
titulo("Hola mundo") == "Hola Mundo"
n_caracteres("Hola mundo") == 10
n_palabras("Hola mundo") == 2
invertida("Hola mundo") == "odnum aloH"
contar_a("Hola mundo") == 1
```

## Requisitos

- [ ] Aplicar `upper()`, `lower()`, `title()`, `len`, `split`, `[::-1]` y `count`.
- [ ] Cada función devuelve el resultado (no imprime).
- [ ] Los tests pasan: `python3 test_main.py`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> ```bash
> python3 test_main.py
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `frase.split()` separa por espacios y devuelve una lista de palabras.
- `frase[::-1]` invierte el string completo.
- `len(frase)` cuenta caracteres; `len(frase.split())` cuenta palabras.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def mayusculas(frase: str) -> str:
    return frase.upper()


def minusculas(frase: str) -> str:
    return frase.lower()


def titulo(frase: str) -> str:
    return frase.title()


def n_caracteres(frase: str) -> int:
    return len(frase)


def n_palabras(frase: str) -> int:
    return len(frase.split())


def invertida(frase: str) -> str:
    return frase[::-1]


def contar_a(frase: str) -> int:
    return frase.count("a")


if __name__ == "__main__":
    frase = "Hola mundo"
    print(f"Mayúsculas: {mayusculas(frase)}")
    print(f"Minúsculas: {minusculas(frase)}")
    print(f"Título: {titulo(frase)}")
    print(f"Caracteres: {n_caracteres(frase)}")
    print(f"Palabras: {n_palabras(frase)}")
    print(f"Invertida: {invertida(frase)}")
    print(f"Veces la letra 'a': {contar_a(frase)}")
````

</details>