# Ejercicio 01 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** variables, tipos, type(), input()
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `variables.py` que:

1. Declare con `str` tu nombre y tu ciudad de nacimiento.
2. Declare con `int` tu edad y con `bool` si estudias programación.
3. Usando `type()`, imprima el tipo de cada variable.
4. Imprima una frase final con **f-strings** que diga: `Soy <nombre>, tengo <edad> años, nací en <ciudad> y es <True|False> que estudio programación.`

Salida esperada (ejemplo):

```
nombre es de tipo <class 'str'>
ciudad es de tipo <class 'str'>
edad es de tipo <class 'int'>
programacion es de tipo <class 'bool'>
Soy Ana, tengo 30 años, nací en Lima y es True que estudio programación.
```

## Requisitos

- [ ] Usar nombres de variables en `snake_case`.
- [ ] Imprimir los 4 tipos con `type()`.
- [ ] La frase final usa f-strings con `{}`.
- [ ] Ejecutarlo localmente con `python3 variables.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Recuerda la sintaxis: `nombre = "Ana"` y `edad = 30`.
- `type()` se usa así: `type(nombre)` y devuelve `<class 'str'>`.
- Dentro de un f-string puedes escribir texto y `{variable}`.
- No hace falta declarar el tipo explícitamente en la variable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
nombre = "Ana"
ciudad = "Lima"
edad = 30
programacion = True

print(f"nombre es de tipo {type(nombre)}")
print(f"ciudad es de tipo {type(ciudad)}")
print(f"edad es de tipo {type(edad)}")
print(f"programacion es de tipo {type(programacion)}")

print(
    f"Soy {nombre}, tengo {edad} años, nací en {ciudad} "
    f"y es {programacion} que estudio programación."
)
````

</details>