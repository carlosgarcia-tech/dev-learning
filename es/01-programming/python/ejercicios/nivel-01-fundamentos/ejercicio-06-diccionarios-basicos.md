# Ejercicio 06 — Diccionarios básicos

- **Nivel:** 1/5
- **Tema:** diccionarios, get, items, iteración
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `diccionarios.py` que:

1. Defina un diccionario `alumno` con claves `nombre`, `edad` y `curso`.
2. Imprima el valor de `nombre` con acceso directo `alumno["nombre"]`.
3. Añada la clave `nota` con valor `18`.
4. Actualice la `edad` a `21`.
5. Imprima `alumno.get("email", "sin email")` para demostrar el valor por defecto.
6. Recorra con `for clave, valor in alumno.items()` imprimiendo `clave: valor`.

Salida esperada:

```
Ana
{'nombre': 'Ana', 'edad': 21, 'curso': 'Matemáticas', 'nota': 18}
sin email
nombre: Ana
edad: 21
curso: Matemáticas
nota: 18
```

## Requisitos

- [ ] Crear el diccionario con `nombre`, `edad` y `curso`.
- [ ] Añadir y actualizar claves con `alumno["..."] = ...`.
- [ ] Usar `.get()` con valor por defecto.
- [ ] Iterar con `.items()`.
- [ ] Ejecutarlo localmente con `python3 diccionarios.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un diccionario se define con llaves: `{"clave": "valor"}`.
- Para añadir: `alumno["nota"] = 18`.
- `for k, v in d.items()` recorre pares clave/valor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
alumno = {"nombre": "Ana", "edad": 20, "curso": "Matemáticas"}

print(alumno["nombre"])

alumno["nota"] = 18
alumno["edad"] = 21

print(alumno)
print(alumno.get("email", "sin email"))

for clave, valor in alumno.items():
    print(f"{clave}: {valor}")
````

</details>