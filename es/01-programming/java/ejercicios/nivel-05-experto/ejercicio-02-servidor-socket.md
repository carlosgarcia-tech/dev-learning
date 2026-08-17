# Ejercicio 02 — Servidor de sockets

- **Nivel:** 5/5
- **Tema:** `ServerSocket`, `Socket`, `BufferedReader`, `PrintWriter`, I/O de red
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `ServidorEco.java` que implemente un servidor de **eco** por TCP:

1. Cree un `ServerSocket` en el puerto `8080` e imprima `Servidor escuchando en el puerto 8080`.
2. Acepte **varias** conexiones en bucle (`while (true)`) con `accept()`.
3. Para cada cliente:
   - Lea líneas con `BufferedReader`.
   - Envíe de vuelta la misma línea precedida de `Eco: ` con `PrintWriter`.
   - Termine cuando el cliente envíe `"salir"` o el socket se cierre.
   - Atienda cada conexión en su propio hilo con `Executors.newCachedThreadPool()` para permitir varios clientes a la vez.
4. Cree también un archivo `ClienteEco.java` que:
   - Se conecte a `localhost:8080` con `Socket`.
   - Envíe `"hola servidor"` y `"salir"` y lea e imprima las respuestas.

Salida esperada del servidor:

```
Servidor escuchando en el puerto 8080
Cliente conectado: /127.0.0.1:...
```

Salida esperada del cliente:

```
Respuesta: Eco: hola servidor
```

## Requisitos

- [ ] El servidor usa `ServerSocket` y `accept()`.
- [ ] Cada cliente se atiende en un hilo (pool de hilos).
- [ ] El servidor responde `Eco: <mensaje>` con `PrintWriter.println`.
- [ ] `ClienteEco.java` se conecta, envía mensajes y lee respuestas.
- [ ] Compilar ambos con `javac ServidorEco.java ClienteEco.java`. Ejecuta el servidor (`java ServidorEco`) en una terminal y el cliente (`java ClienteEco`) en otra.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `new ServerSocket(8080)` lanza `IOException` (checked).
- `BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()))`.
- `PrintWriter out = new PrintWriter(socket.getOutputStream(), true)` — el `true` activa flush automático.
- `linea = in.readLine()` devuelve `null` cuando el cliente cierra.
- El pool: `ExecutorService pool = Executors.newCachedThreadPool();` y `pool.submit(() -> atenderCliente(socket))`.
- Los streams se cierran solos con try-with-resources sobre el socket.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ServidorEco {
    public static void main(String[] args) throws Exception {
        ExecutorService pool = Executors.newCachedThreadPool();
        try (ServerSocket server = new ServerSocket(8080)) {
            System.out.println("Servidor escuchando en el puerto 8080");
            while (true) {
                Socket socket = server.accept();
                System.out.println("Cliente conectado: " + socket.getRemoteSocketAddress());
                pool.submit(() -> atender(socket));
            }
        }
    }

    private static void atender(Socket socket) {
        try (socket;
             BufferedReader in = new BufferedReader(
                     new InputStreamReader(socket.getInputStream()));
             PrintWriter out = new PrintWriter(socket.getOutputStream(), true)) {
            String linea;
            while ((linea = in.readLine()) != null) {
                if (linea.equals("salir")) {
                    break;
                }
                out.println("Eco: " + linea);
            }
        } catch (Exception e) {
            System.out.println("Error con el cliente: " + e.getMessage());
        }
    }
}
````

</details>

<details>
<summary>Mostrar solución del cliente</summary>

````java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ClienteEco {
    public static void main(String[] args) throws Exception {
        try (Socket socket = new Socket("localhost", 8080);
             PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
             BufferedReader in = new BufferedReader(
                     new InputStreamReader(socket.getInputStream()))) {

            out.println("hola servidor");
            System.out.println("Respuesta: " + in.readLine());

            out.println("salir");
            System.out.println("Cliente desconectado.");
        }
    }
}
````

</details>