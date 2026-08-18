# Ejercicio 02 — Clases y herencia

- **Nivel:** 3/5
- **Tema:** __init__, métodos, self, herencia, super, @property
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` para que implemente:

1. La clase `Animal` con `__init__(self, nombre)` y un método `hablar()` que devuelva `"..."`.
2. La clase `Perro(Animal)` que sobrescriba `hablar()` para devolver `"Guau"`.
3. La clase `Gato(Animal)` que sobrescriba `hablar()` para devolver `"Miau"`.
4. Un método `correr()` en `Perro` que devuelva `"{nombre} corre rápido"` usando `self.nombre`.
5. `super().__init__(nombre)` en las subclases para inicializar el nombre.
6. Una propiedad `@property` en `Animal` llamada `descripcion` que devuelva `"{nombre} es un animal"`, y en `Perro` una propiedad `nombre` con setter que no permita nombres vacíos (lanza `ValueError`).

El bloque `if __name__ == "__main__":` puede servir de demo: imprime `hablar()` de un perro y un gato, `correr()` de un perro, la `descripcion` de ambos, y comprueba que asignar `""` al nombre del perro lanza `ValueError` (capturado con try/except).

Salida esperada:

```
Guau
Miau
Rex corre rápido
Rex es un animal
Mishi es un animal
Error: el nombre no puede estar vacío
```

## Requisitos

- [ ] Crear las clases `Animal`, `Perro` y `Gato` con herencia.
- [ ] Usar `super().__init__(nombre)`.
- [ ] Sobrescribir `hablar()`.
- [ ] Usar `@property` para `descripcion` y para el nombre de `Perro`.
- [ ] Lanzar `ValueError` en un setter con nombre vacío.
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

- La herencia se declara entre paréntesis: `class Perro(Animal):`.
- `super().__init__(nombre)` llama al `__init__` de la clase padre.
- Un setter se define así: `@nombre.setter` después de la propiedad.
- Para asignar un nombre nuevo usa el setter a través del atributo `nombre`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
class Animal:
    def __init__(self, nombre):
        self.nombre = nombre

    def hablar(self):
        return "..."

    @property
    def descripcion(self):
        return f"{self.nombre} es un animal"


class Perro(Animal):
    def __init__(self, nombre):
        super().__init__(nombre)

    def hablar(self):
        return "Guau"

    def correr(self):
        return f"{self.nombre} corre rápido"

    @property
    def nombre(self):
        return self._nombre

    @nombre.setter
    def nombre(self, valor):
        if not valor:
            raise ValueError("el nombre no puede estar vacío")
        self._nombre = valor


class Gato(Animal):
    def __init__(self, nombre):
        super().__init__(nombre)

    def hablar(self):
        return "Miau"


if __name__ == "__main__":
    rex = Perro("Rex")
    mishi = Gato("Mishi")

    print(rex.hablar())
    print(mishi.hablar())
    print(rex.correr())
    print(rex.descripcion)
    print(mishi.descripcion)

    try:
        rex.nombre = ""
    except ValueError as e:
        print(f"Error: {e}")
````

</details>