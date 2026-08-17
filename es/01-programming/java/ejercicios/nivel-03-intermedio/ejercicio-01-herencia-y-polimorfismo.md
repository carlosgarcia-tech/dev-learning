# Ejercicio 01 — Herencia y polimorfismo

- **Nivel:** 3/5
- **Tema:** `extends`, `super`, `@Override`, polimorfismo
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `Animales.java` que:

1. Defina una clase base `Animal` con campo `nombre` (String), constructor, método `hacerSonido()` que devuelva `"..."` y método `getNombre()`.
2. Defina `Perro` y `Gato` que extiendan `Animal`, con constructor que use `super(nombre)` y **sobrescriban** `hacerSonido()` devolviendo `"Guau"` y `"Miau"` respectivamente.
3. En `main`:
   - Cree un array `Animal[]` con un perro, un gato y un animal genérico.
   - Recorra el array y para cada elemento imprima: `"<nombre> dice <sonido>"` — esto demuestra **polimorfismo**: el mismo método se comporta según el tipo real del objeto.
   - Cree una referencia `Animal` apuntando a un `Perro` e invoque `hacerSonido()`.

Salida esperada:

```
Rex dice Guau
Misi dice Miau
Animal dice ...
Rex dice Guau
```

## Requisitos

- [ ] `Perro` y `Gato` extienden `Animal` con `extends`.
- [ ] Los constructores usan `super(nombre)`.
- [ ] Sobrescribir `hacerSonido()` con `@Override`.
- [ ] Demostrar polimorfismo recorriendo un array `Animal[]`.
- [ ] Compilarlo localmente con `javac Animales.java` y ejecutarlo con `java Animales` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `class Perro extends Animal { ... }`.
- `super(nombre)` llama al constructor de la clase padre.
- `@Override` no es obligatorio, pero marca que sobrescribes (el compilador lo verifica).
- Si el array es `Animal[]`, el método llamado es el del **tipo real** (polimorfismo dinámico).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Animales {
    static class Animal {
        protected String nombre;

        public Animal(String nombre) {
            this.nombre = nombre;
        }

        public String getNombre() {
            return nombre;
        }

        public String hacerSonido() {
            return "...";
        }
    }

    static class Perro extends Animal {
        public Perro(String nombre) {
            super(nombre);
        }

        @Override
        public String hacerSonido() {
            return "Guau";
        }
    }

    static class Gato extends Animal {
        public Gato(String nombre) {
            super(nombre);
        }

        @Override
        public String hacerSonido() {
            return "Miau";
        }
    }

    public static void main(String[] args) {
        Animal[] animales = {new Perro("Rex"), new Gato("Misi"), new Animal("Animal")};

        for (Animal a : animales) {
            System.out.println(a.getNombre() + " dice " + a.hacerSonido());
        }

        Animal ref = new Perro("Rex");
        System.out.println(ref.getNombre() + " dice " + ref.hacerSonido());
    }
}
````

</details>