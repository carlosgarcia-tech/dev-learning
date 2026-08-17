# Ejercicio 04 — Genéricos básicos

- **Nivel:** 3/5
- **Tema:** clases genéricas, métodos genéricos, tipo `T`, bounded type
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `Caja.java` que:

1. Defina una clase genérica `Caja<T>` con un campo `contenido` de tipo `T`, un constructor, `get()` y `set(T nuevo)`.
2. Defina un método genérico `static <T> void imprimirContenido(Caja<T> caja)` que imprima el contenido con `System.out.println(caja.get())`.
3. Defina un método genérico con restricción `static <T extends Number> double duplicar(Caja<T> caja)` que devuelva `caja.get().doubleValue() * 2`.
4. En `main`:
   - Cree una `Caja<String>` con `"hola"` y una `Caja<Integer>` con `7`.
   - Imprima sus contenidos con el método genérico.
   - Llame a `duplicar` con la caja de enteros e imprima el resultado.
   - Compruebe que cambiar el contenido con `set` funciona.

Salida esperada:

```
Contenido: hola
Contenido: 7
Duplicado de 7 = 14.0
Tras set: 99
```

## Requisitos

- [ ] La clase `Caja<T>` usa un parámetro de tipo genérico.
- [ ] Hay al menos un método genérico con `<T>` propio.
- [ ] Un método usa `T extends Number` (bounded type) para llamar a `doubleValue()`.
- [ ] Compilarlo localmente con `javac Caja.java` y ejecutarlo con `java Caja` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `class Caja<T> { private T contenido; ... }`.
- Método genérico: `static <T> void imprimirContenido(Caja<T> caja)`.
- `<T extends Number>` permite llamar a métodos de `Number` como `doubleValue()`.
- Los primitivos no se pueden usar como tipo genérico: usa `Integer`, `Double`, etc.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Caja<T> {
    private T contenido;

    public Caja(T contenido) {
        this.contenido = contenido;
    }

    public T get() {
        return contenido;
    }

    public void set(T nuevo) {
        this.contenido = nuevo;
    }

    public static <T> void imprimirContenido(Caja<T> caja) {
        System.out.println("Contenido: " + caja.get());
    }

    public static <T extends Number> double duplicar(Caja<T> caja) {
        return caja.get().doubleValue() * 2;
    }

    public static void main(String[] args) {
        Caja<String> cajaTexto = new Caja<>("hola");
        Caja<Integer> cajaNumero = new Caja<>(7);

        imprimirContenido(cajaTexto);   // Contenido: hola
        imprimirContenido(cajaNumero);  // Contenido: 7

        System.out.println("Duplicado de 7 = " + duplicar(cajaNumero));

        cajaNumero.set(99);
        System.out.println("Tras set: " + cajaNumero.get());
    }
}
````

</details>