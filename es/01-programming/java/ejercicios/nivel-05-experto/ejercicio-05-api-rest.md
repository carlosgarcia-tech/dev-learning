# Ejercicio 05 — API REST con el JDK

- **Nivel:** 5/5
- **Tema:** `com.sun.net.httpserver.HttpServer`, `HttpHandler`, JSON manual, `HttpClient`
- **Tiempo estimado:** 50 min

## Enunciado

Crea un archivo `ApiRest.java` que implemente una **API REST** usando `com.sun.net.httpserver` (el servidor HTTP que viene integrado en el JDK):

1. Almacene las "tareas" en memoria: `List<String> tareas` (inicializada con `{"comprar pan", "estudiar java"}`).
2. `HttpServer.create(new InetSocketAddress(8080), 0)` en `localhost:8080`.
3. Cree un contexto `"/tareas"` que atienda:
   - `GET` → responde `200` con las tareas como JSON: `{"tareas":["comprar pan","estudiar java"]}`.
   - `POST` → lee el cuerpo (`{"tarea":"<texto>"}`), añade la tarea y responde `201` con la tarea creada.
   - Otro método → responde `405` con `{"error":"método no permitido"}`.
4. Con `HttpServer`, cree también un contexto `"/health"` que responda `{"status":"ok"}`.
5. Arranque con `server.start()`, imprima `API escuchando en http://localhost:8080` y cierre con un `Runtime` shutdown hook.
6. El JSON se construye **a mano** con `String.format`/concatenación (sin librerías).

Salida esperada al probar con `curl` (en otra terminal):

```
$ curl http://localhost:8080/tareas
{"tareas":["comprar pan","estudiar java"]}

$ curl -X POST http://localhost:8080/tareas -d '{"tarea":"leer libro"}'
{"tarea":"leer libro"}

$ curl http://localhost:8080/health
{"status":"ok"}
```

## Requisitos

- [ ] Servidor con `com.sun.net.httpserver.HttpServer` (JDK integrado, sin dependencias).
- [ ] Contexto `/tareas` que distinga `GET` y `POST` por método.
- [ ] Leer el cuerpo de la petición con `exchange.getRequestBody()`.
- [ ] Responder con códigos `200`, `201` y `405` y cuerpo JSON.
- [ ] Probar con `curl` (o `HttpClient`) y verificar las respuestas.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `exchange.getRequestMethod()` devuelve `"GET"`, `"POST"`, etc.
- Respuesta: `exchange.getResponseHeaders().set("Content-Type", "application/json");` y `exchange.sendResponseHeaders(200, bytes.length)`.
- `exchange.getResponseBody()` devuelve un `OutputStream` para escribir la respuesta.
- Para leer el cuerpo: `new String(exchange.getRequestBody().readAllBytes())`.
- `server.setExecutor(Executors.newCachedThreadPool())` permite atender varios clientes.
- Necesitas un contador para generar `id` en `POST`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;

public class ApiRest {
    private static final List<String> tareas = new ArrayList<>(
            List.of("comprar pan", "estudiar java"));

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.setExecutor(Executors.newCachedThreadPool());

        server.createContext("/tareas", ApiRest::manejarTareas);
        server.createContext("/health", ApiRest::manejarHealth);

        server.start();
        System.out.println("API escuchando en http://localhost:8080");

        Runtime.getRuntime().addShutdownHook(new Thread(() -> server.stop(0)));
    }

    private static void manejarTareas(HttpExchange exchange) throws IOException {
        String metodo = exchange.getRequestMethod();

        if ("GET".equals(metodo)) {
            StringBuilder json = new StringBuilder("{\"tareas\":[");
            for (int i = 0; i < tareas.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                json.append("\"").append(tareas.get(i)).append("\"");
            }
            json.append("]}");
            responder(exchange, 200, json.toString());
        } else if ("POST".equals(metodo)) {
            String cuerpo = new String(exchange.getRequestBody().readAllBytes(),
                    StandardCharsets.UTF_8);
            String nueva = extraerTarea(cuerpo);
            tareas.add(nueva);
            responder(exchange, 201, "{\"tarea\":\"" + nueva + "\"}");
        } else {
            responder(exchange, 405, "{\"error\":\"método no permitido\"}");
        }
    }

    private static void manejarHealth(HttpExchange exchange) throws IOException {
        responder(exchange, 200, "{\"status\":\"ok\"}");
    }

    private static String extraerTarea(String json) {
        String sinLlaves = json.replace("{", "").replace("}", "");
        String[] partes = sinLlaves.split(":");
        return partes.length >= 2 ? partes[1].replace("\"", "").trim() : "";
    }

    private static void responder(HttpExchange exchange, int codigo, String cuerpo)
            throws IOException {
        byte[] bytes = cuerpo.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "application/json");
        exchange.sendResponseHeaders(codigo, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(bytes);
        }
    }
}
````

</details>