# Ejercicio 05 — Anotaciones

- **Nivel:** 4/5
- **Tema:** anotaciones, `@Retention`, `@Target`, reflexión básica
- **Tiempo estimado:** 35 min

## Enunciado

Crea un archivo `Anotaciones.java` que:

1. Defina una anotación `@MiAnotacion` con:
   - `@Retention(RetentionPolicy.RUNTIME)` — para poder leerla con reflexión.
   - `@Target(ElementType.METHOD)` — solo para métodos.
   - Un elemento `String valor() default "sin valor"`.
2. Aplique `@MiAnotacion(valor = "hola")` a un método `metodoConAnotacion()` y `@MiAnotacion` (por defecto) a `otroMetodo()`.
3. Usando reflexión (`Class.getDeclaredMethods()`, `Method.isAnnotationPresent(...)`, `getAnnotation(...)`), recorra los métodos de la clase y, para los que tengan la anotación, imprima: `"<nombreMetodo> -> <valor>"`.
4. Defina la anotación `@Deprecated` sobre un método antiguo y compruebe que el programa sigue funcionando (aparecerá un warning al compilar).

Salida esperada:

```
metodoConAnotacion -> hola
otroMetodo -> sin valor
Método antiguo llamado
```

## Requisitos

- [ ] La anotación se declara con `@interface`.
- [ ] Usar `@Retention(RUNTIME)` y `@Target(METHOD)`.
- [ ] Leer anotaciones por reflexión con `isAnnotationPresent` y `getAnnotation`.
- [ ] Marcar un método con `@Deprecated`.
- [ ] Compilarlo localmente con `javac Anotaciones.java` y ejecutarlo con `java Anotaciones` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `@interface MiAnotacion { String valor() default "sin valor"; }`.
- `@Target(ElementType.METHOD)` restringe dónde se puede aplicar.
- `@Retention(RetentionPolicy.RUNTIME)` permite leerla con reflexión en ejecución.
- `Anotaciones.class.getDeclaredMethods()` devuelve los métodos declarados en la clase.
- `m.isAnnotationPresent(MiAnotacion.class)` comprueba si la tiene; `m.getAnnotation(MiAnotacion.class).valor()` lee el valor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Method;

public class Anotaciones {

    @Retention(RetentionPolicy.RUNTIME)
    @Target(ElementType.METHOD)
    @interface MiAnotacion {
        String valor() default "sin valor";
    }

    @MiAnotacion(valor = "hola")
    public void metodoConAnotacion() {
    }

    @MiAnotacion
    public void otroMetodo() {
    }

    @Deprecated
    public void metodoAntiguo() {
        System.out.println("Método antiguo llamado");
    }

    public static void main(String[] args) throws Exception {
        Anotaciones obj = new Anotaciones();
        obj.metodoAntiguo();

        for (Method m : Anotaciones.class.getDeclaredMethods()) {
            if (m.isAnnotationPresent(MiAnotacion.class)) {
                MiAnotacion an = m.getAnnotation(MiAnotacion.class);
                System.out.println(m.getName() + " -> " + an.valor());
            }
        }
    }
}
````

</details>