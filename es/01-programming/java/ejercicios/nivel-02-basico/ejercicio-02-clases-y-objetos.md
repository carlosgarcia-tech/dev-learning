# Ejercicio 02 — Clases y objetos

- **Nivel:** 2/5
- **Tema:** clases, atributos, constructores, `new`, métodos de instancia
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `Libro.java` que defina una clase `Libro` y un método `main` en la misma clase:

1. La clase `Libro` tiene los atributos `titulo` (String), `autor` (String) y `paginas` (int).
2. Un constructor que reciba los tres valores y los asigne.
3. Un método `descripcion()` que devuelva: `"<titulo> de <autor> (<paginas> páginas)"`.
4. Un método `esExtenso()` que devuelva `true` si el libro tiene más de 300 páginas.
5. En `main`, crea **dos** libros con `new`, imprime su descripción y si son extensos.

Salida esperada:

```
Cien años de soledad de Gabriel García Márquez (432 páginas)
¿Extenso? true
El principito de Antoine de Saint-Exupéry (96 páginas)
¿Extenso? false
```

## Requisitos

- [ ] La clase tiene atributos, constructor y métodos de instancia.
- [ ] Usar `this.titulo = titulo;` para asignar en el constructor.
- [ ] Crear dos objetos independientes con `new Libro(...)`.
- [ ] Llamar a los métodos de instancia sobre cada objeto.
- [ ] Compilarlo localmente con `javac Libro.java` y ejecutarlo con `java Libro` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El constructor no lleva tipo de retorno y se llama igual que la clase.
- Un método de instancia NO es `static`; se invoca con `libro.descripcion()`.
- Los objetos son independientes: cambiar `titulo` en uno no afecta al otro.
- Puedes poner `main` dentro de la misma clase `Libro`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Libro {
    private String titulo;
    private String autor;
    private int paginas;

    public Libro(String titulo, String autor, int paginas) {
        this.titulo = titulo;
        this.autor = autor;
        this.paginas = paginas;
    }

    public String descripcion() {
        return titulo + " de " + autor + " (" + paginas + " páginas)";
    }

    public boolean esExtenso() {
        return paginas > 300;
    }

    public static void main(String[] args) {
        Libro l1 = new Libro("Cien años de soledad",
                "Gabriel García Márquez", 432);
        Libro l2 = new Libro("El principito",
                "Antoine de Saint-Exupéry", 96);

        System.out.println(l1.descripcion());
        System.out.println("¿Extenso? " + l1.esExtenso());
        System.out.println(l2.descripcion());
        System.out.println("¿Extenso? " + l2.esExtenso());
    }
}
````

</details>