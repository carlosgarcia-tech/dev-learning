# Ejercicio 01 — Hola mundo

- **Nivel:** 1/5
- **Tema:** método `main`, `System.out.println`, compilación y ejecución
- **Tiempo estimado:** 10 min

## Enunciado

Crea un archivo `HolaMundo.java` que:

1. Defina una clase pública llamada `HolaMundo` (el archivo debe llamarse igual).
2. Contenga el método `main` con la firma `public static void main(String[] args)`.
3. Imprima con `System.out.println` el texto: `¡Hola, mundo! Aprendo Java.`
4. Imprima además tu nombre en una segunda línea.

Salida esperada (ejemplo):

```
¡Hola, mundo! Aprendo Java.
Me llamo Ana
```

## Requisitos

- [ ] La clase pública se llama `HolaMundo` y está en `HolaMundo.java`.
- [ ] Usar la firma exacta `public static void main(String[] args)`.
- [ ] Imprimir las dos líneas con `System.out.println`.
- [ ] Compilarlo localmente con `javac HolaMundo.java` y ejecutarlo con `java HolaMundo` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un archivo con clase pública `HolaMundo` debe llamarse obligatoriamente `HolaMundo.java`.
- Todo programa empieza dentro de las llaves del método `main`.
- `System.out.println("texto");` imprime texto y salta de línea.
- Recuerda cerrar con punto y coma cada sentencia.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class HolaMundo {
    public static void main(String[] args) {
        System.out.println("¡Hola, mundo! Aprendo Java.");
        System.out.println("Me llamo Ana");
    }
}
````

</details>