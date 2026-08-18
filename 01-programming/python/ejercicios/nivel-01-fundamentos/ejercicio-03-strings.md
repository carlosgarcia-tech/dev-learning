# Ejercicio 03 — Strings

- **Nivel:** 1/5
- **Tema:** métodos de strings, f-strings, slicing
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `strings.py` que:

1. Pida al usuario una frase con `input()`.
2. Muestre la frase en mayúsculas (`upper()`), minúsculas (`lower()`) y con la primera letra de cada palabra en mayúscula (`title()`).
3. Muestre el número de caracteres (`len`) y de palabras (`split`).
4. Muestre la frase invertida (slicing con `[::-1]`).
5. Cuente cuántas veces aparece la letra `a` (`count("a")`).

Salida esperada (ejemplo con `Hola mundo`):

```
Mayúsculas: HOLA MUNDO
Minúsculas: hola mundo
Título: Hola Mundo
Caracteres: 10
Palabras: 2
Invertida: odnum aloH
Veces la letra 'a': 1
```

## Requisitos

- [ ] Usar `input()` para leer la frase.
- [ ] Aplicar `upper()`, `lower()`, `title()`, `len`, `split`, `[::-1]` y `count`.
- [ ] Mostrar todas las salidas con f-strings.
- [ ] Ejecutarlo localmente con `python3 strings.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La frase ya viene con `input()`, no hay que convertirla.
- `frase.split()` separa por espacios y devuelve una lista de palabras.
- `frase[::-1]` invierte el string completo.
- `len(frase)` cuenta caracteres; `len(frase.split())` cuenta palabras.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
frase = input("Escribe una frase: ")

print(f"Mayúsculas: {frase.upper()}")
print(f"Minúsculas: {frase.lower()}")
print(f"Título: {frase.title()}")
print(f"Caracteres: {len(frase)}")
print(f"Palabras: {len(frase.split())}")
print(f"Invertida: {frase[::-1]}")
print(f"Veces la letra 'a': {frase.count('a')}")
````

</details>