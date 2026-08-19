# 06 — Axum y Actix-web

Rust no necesita un *runtime* especial para servir HTTP: hay varios frameworks maduros y de alto rendimiento. Esta guía presenta los dos más usados: **Axum** (ecosistema `tokio`) y **Actix-web** (runtime propio, `actix-rt`). Ambos sirven decenas de miles de peticiones por segundo, pero difieren en filosofía, modelo de concurrencia y curva de aprendizaje. Aquí construirás servidores con rutas, parámetros, JSON, estado compartido, middlewares y tests, para poder elegir el que mejor encaje en tu proyecto.

> Esta es la primera guía que **no usa solo la biblioteca estándar**: necesitas Cargo y dependencias externas. Asume que dominas `Result`, `Arc`, `Mutex`, serde (derives) y el patrón `match` de capítulos anteriores.

## Objetivos

- [ ] Comprender qué es Axum y qué es Actix-web, y en qué se diferencian (modelo, runtime y ecosistema).
- [ ] Crear un proyecto con `cargo new` y añadir dependencias con `cargo add`.
- [ ] Configurar `tokio` como runtime asíncrono y usarlo con la macro `#[tokio::main]`.
- [ ] Levantar un servidor HTTP mínimo con `Router::new()` y rutas `get`/`post` en Axum.
- [ ] Escribir *handlers* como funciones `async fn` que devuelven impl `IntoResponse`.
- [ ] Compartir estado de solo lectura entre handlers con `Arc<AppState>` / `State<T>`.
- [ ] Capturar parámetros de ruta (`/{id}`) con el extractor `Path<T>`.
- [ ] Leer parámetros de consulta (`?nombre=x`) con `Query<T>`.
- [ ] Serializar y deserializar JSON con `serde` y el extractor `Json<T>`.
- [ ] Mantener estado mutable compartido con `Arc<Mutex<T>>` (patrón repositorio en memoria).
- [ ] Devolver códigos HTTP con `StatusCode` e implementar `IntoResponse`.
- [ ] Montar un servidor mínimo con Actix-web (`HttpServer`, `App`, `web::get`, `web::Data`) y escribir handlers que devuelven `impl Responder` con `web::Json`.
- [ ] Añadir middlewares con `tower-http` (trace, CORS, compresión) y `fallback` en Axum.
- [ ] Probar handlers sin levantar un socket usando `tower::ServiceExt::oneshot`.
- [ ] Compilar en modo `--release` y enlazar el servidor a `0.0.0.0` para desplegar.

## Apuntes

### ¿Qué es Axum? ¿Qué es Actix-web?

**Axum** es un framework HTTP construido sobre `tokio` y `hyper`, mantenido por el equipo de Tokio. Se integra de forma natural con `tower` (middlewares), `tower-http`, `serde` y `tracing`. Su filosofía es **componer con tipos**: cada ruta es un servicio, los extractores son traits que el compilador resuelve y casi todo es verificable en tiempo de compilación.

**Actix-web** es un framework maduro (desde 2017) y autónomo. Tiene su propio runtime (`actix-rt`, basado en `tokio`) y un framework de actores opcional. Su rasgo distintivo es el **modelo de actores**: cada worker procesa peticiones y el estado suele vivir dentro de un actor con buzón de mensajes. Es famoso por sus benchmarks y por una API muy ergonómica con macros declarativas.

Si ya usas `tokio`, `tracing` y `tower`, Axum encaja mejor; si prefieres un framework todo-en-uno con macros, elige Actix-web.

#### Diferencias entre Axum y Actix-web

| Criterio | Axum | Actix-web |
|---|---|---|
| Runtime asíncrono | `tokio` (externo, lo gestionas tú) | `actix-rt` (lo gestiona el framework) |
| Modelo de concurrencia | Workers de `tokio` + composición de servicios | Workers propios + actores opcionales |
| Extracción de parámetros | Traits `FromRequestParts`/`FromRequest` (tipado) | Macros de extracción (`web::Path`, `web::Query`, `web::Json`) |
| Middlewares | Ecosistema `tower` / `tower-http` (layers) | Propios (`wrap`, `wrap_fn`) |
| Estado compartido | `Arc<AppState>` explícito o `State<T>` | `web::Data<T>` (wrapper de `Arc`) |
| Rendimiento | Muy alto (sostenido en benchmarks) | Muy alto (clásicamente el más rápido) |
| Curva de aprendizaje | Media-alta: exige entender `Service`, extractores y orden de argumentos | Media: macros declarativas, pero el modelo de actores añade un concepto nuevo |
| Integración | `tracing`, `tokio`, `hyper`, `sqlx`, `reqwest` | Ecosistema propio + compatibilidad con Tokio |
| Versión actual estable | 0.8 | 4 |

### Cargo y dependencias

A partir de esta guía dejamos de usar `rustc` con archivos sueltos y trabajamos con **proyectos Cargo** (`cargo new mi_backend`).

#### Añadir dependencias con cargo add

`cargo add` (Cargo ≥ 1.62) añade dependencias a `Cargo.toml` con las versiones adecuadas. Para Axum:

```bash
cargo add axum@0.8
cargo add tokio@1 --features full
cargo add serde@1 --features derive
cargo add serde_json@1
cargo add tower-http@0.6 --features cors,trace,compression-gzip
cargo add tracing@0.1 tracing-subscriber@0.3 --features env-filter,fmt
```

Esto genera en `Cargo.toml`:

```toml
axum = "0.8"
tokio = { version = "1", features = ["full"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
tower-http = { version = "0.6", features = ["cors", "trace", "compression-gzip"] }
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter", "fmt"] }
```

> `tokio` no aparece "casi" en el código (lo invoca `#[tokio::main]`), pero el runtime es imprescindible: sin él `main` no puede ejecutar `async`. La feature `full` incluye `rt-multi-thread`, `macros`, `net`, `time`, `signal`, etc.

Para Actix-web, el mínimo viable es `cargo add actix-web@4` + `cargo add serde@1 --features derive` + `cargo add serde_json@1`.

#### El runtime async: tokio con #[tokio::main]

Una `main` normal no puede llamar `.await` directamente. La macro `#[tokio::main]` transforma `async fn main()` en un `fn main()` que arranca el runtime y ejecuta tu función dentro de él. No hace falta `Runtime::new()` a mano salvo en bibliotecas o tests.

### Servidor HTTP mínimo con Axum

Un servidor Axum tiene tres piezas: un **router** (rutas + handlers), un **listener** (`TcpListener`) y el **servicio** que se entrega a `axum::serve` (en Axum 0.8 no existe `Router::serve`). El `bind` ocurre antes de servir, así que un puerto ocupado falla temprano:

```rust
use axum::{routing::get, Router};

async fn raiz() -> &'static str {
    "¡Hola desde Axum!"
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(raiz));
    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000").await.unwrap();
    println!("Servidor escuchando en http://127.0.0.1:3000");
    axum::serve(listener, app).await.unwrap();
}
```

#### Router::new y get/post

`Router::new()` construye un router vacío y cada `.route()` asocia un patrón de URL con un método y su handler. Fíjate en `.route("/usuarios", get(listar).post(crear))`: `get()` y `post()` devuelven *method routers* combinables para montar dos verbos en la misma ruta. También existen `put`, `patch`, `delete`, `any` y `route_service`.

#### async fn handlers

Un handler es cualquier función que devuelve algo que implementa `IntoResponse` (puede ser `async` o síncrona). Los extractores van como parámetros y Axum los infiere por tipo y **orden**: si un parámetro no implementa el extractor esperado, el compilador lo rechaza (nada de errores en runtime).

`IntoResponse` lo implementan `&'static str`, `String`, `Vec<u8>`, `StatusCode`, `Json<T>`, tuplas `(StatusCode, T)` y `Result<T, E>`. Devolver `String` produce `200 OK` con `Content-Type: text/plain`.

#### Arc<AppState> para estado compartido

El estado (configuración, conexiones a BD, repositorios) se define en un `struct` `Clone` que el framework clona en cada handler. Se registra con `.with_state(...)` y se extrae con `State<T>`:

```rust
use axum::{extract::State, routing::get, Router};

#[derive(Clone)]
struct AppState {
    nombre_servidor: String,
}

async fn raiz(State(state): State<AppState>) -> String {
    format!("Servidor: {}", state.nombre_servidor)
}

fn app() -> Router {
    Router::new()
        .route("/", get(raiz))
        .with_state(AppState { nombre_servidor: String::from("mi-api") })
}
```

> La primera versión de Axum usaba `Arc<AppState>` clonado a mano. Desde 0.6 se prefiere `State<AppState>` porque el framework clona por ti (tu struct debe ser `Clone`). Para estado **mutable** usaremos `Arc<Mutex<T>>` dentro de `AppState`.

### Rutas y parámetros

#### Path params (/{id})

Los segmentos dinámicos se declaran con `{nombre}` y se capturan con `Path<T>`; el patrón se registra con `.route("/usuarios/{id}", get(ver_usuario))`. Axum 0.7+ usa llaves: `/{id}` (antes `/:id`). Si `Path<u32>` no puede parsear, el framework responde `400` solo. Para varios parámetros usa una tupla `Path<(String, u32)>` (mismo orden que en la ruta):

```rust
use axum::{extract::Path, routing::get, Router};

async fn ver_usuario(Path(id): Path<u32>) -> String {
    format!("Usuario con id {id}")
}
```

#### Query params (Query<T>)

Los parámetros `?clave=valor` se leen con `Query<T>`, donde `T` es un struct con `Deserialize`. Campos ausentes dan `None` si son `Option`, o `400` si son obligatorios; campos no declarados se ignoran:

```rust
use axum::{extract::Query, routing::get, Router};
use serde::Deserialize;

#[derive(Deserialize)]
struct Filtros {
    categoria: Option<String>,
    limite: Option<u32>,
}

async fn buscar(Query(filtros): Query<Filtros>) -> String {
    format!("Buscando en {:?} con límite {:?}", filtros.categoria, filtros.limite)
}
```

#### JSON con serde: extractores Json<T>

`Json<T>` actúa como extractor (entrada, deserializa en `T`) y como respuesta (salida, serializa `T`). Solo requiere `Content-Type: application/json` en la petición. Si el cuerpo es inválido o no encaja con `T`, Axum responde `400` sin que escribas un `match`:

```rust
use axum::{Json, routing::post, Router};
use serde::{Deserialize, Serialize};

#[derive(Deserialize)]
struct NuevoUsuario {
    nombre: String,
    email: String,
}

#[derive(Serialize)]
struct Usuario {
    id: u32,
    nombre: String,
    email: String,
}

async fn crear_usuario(Json(datos): Json<NuevoUsuario>) -> Json<Usuario> {
    Json(Usuario { id: 42, nombre: datos.nombre, email: datos.email })
}
```

### Estado compartido con Arc<Mutex<T>>

Cuando los handlers **mutan** el estado (insertar, actualizar, borrar), el compilador exige interior mutability y tipos `Send + Sync`: `Arc<Mutex<T>>`. `Arc` da el clon barato; `Mutex` da exclusión mutua; la combinación vive dentro de `State`.

#### AppState con repositorio en memoria

El patrón `#[derive(Clone)] struct AppState { repos: Arc<Mutex<...>> }` es la base de cualquier servidor con estado mutable: cada handler se queda con una copia de `AppState` (que comparte el `Arc`) y no con el estado en sí.

```rust
use std::{collections::HashMap, sync::{Arc, Mutex}};
use axum::{extract::State, routing::get, Json, Router};
use serde::{Deserialize, Serialize};

#[derive(Clone)]
struct AppState {
    repos: Arc<Mutex<HashMap<u32, String>>>,
}

#[derive(Serialize)]
struct Repo {
    id: u32,
    nombre: String,
}

async fn listar_repos(State(state): State<AppState>) -> Json<Vec<Repo>> {
    let repos = state.repos.lock().unwrap();
    let lista = repos
        .iter()
        .map(|(id, nombre)| Repo { id: *id, nombre: nombre.clone() })
        .collect();
    Json(lista)
}
```

#### Modificar estado desde handlers (async + Mutex)

Un handler `async` puede mantener una `MutexGuard` en un `.await` (el `Mutex` de `std` es "poisonable", no "await-safe"), pero conviene **soltar la guardia antes del `.await`** cerrando el bloque. En producción, si la guardia cruza `.await`, usa `tokio::sync::Mutex` (await-safe, no poisonable) o `RwLock` cuando las lecturas dominen:

```rust
async fn crear_repo(
    State(state): State<AppState>,
    Json(payload): Json<NuevoRepo>,
) -> Json<Repo> {
    let nuevo_id = {
        let mut repos = state.repos.lock().unwrap();
        let nuevo_id = (repos.len() as u32) + 1;
        repos.insert(nuevo_id, payload.nombre.clone());
        nuevo_id // la guardia se suelta aquí
    };

    Json(Repo { id: nuevo_id, nombre: payload.nombre })
}
```

### Errores y status codes

#### StatusCode y IntoResponse

`StatusCode` implementa `IntoResponse`, así que puedes devolverlo directamente. Con `impl IntoResponse` debes convertir cada rama con `.into_response()` porque ambas deben tener el mismo tipo concreto:

```rust
use axum::{http::StatusCode, Json, response::IntoResponse};

async fn crear(Json(datos): Json<NuevoUsuario>) -> impl IntoResponse {
    if datos.nombre.is_empty() {
        return (StatusCode::BAD_REQUEST, "El nombre no puede estar vacío").into_response();
    }
    (StatusCode::CREATED, Json(datos)).into_response()
}
```

#### Result<T, (StatusCode, String)> en handlers

El idiomático para errores es devolver `Result<T, (StatusCode, String)>`. Axum convierte `Ok` en la respuesta de `T` y `Err((status, msg))` en una respuesta con ese código y cuerpo `text/plain`. `Result<T, E>` implementa `IntoResponse` cuando `T: IntoResponse` y `E: IntoResponse`:

```rust
type ApiError = (StatusCode, String);

async fn ver_repo(
    State(state): State<AppState>,
    Path(id): Path<u32>,
) -> Result<Json<Repo>, ApiError> {
    let repos = state.repos.lock().unwrap();

    match repos.get(&id) {
        Some(nombre) => Ok(Json(Repo { id, nombre: nombre.clone() })),
        None => Err((StatusCode::NOT_FOUND, format!("El repo {id} no existe"))),
    }
}
```

### Actix-web: servidor mínimo

Actix-web usa su propio runtime (`actix-rt`). La app se monta con `App::new().route(...)`, se envuelve en `HttpServer` (varios workers) y se inicia con `.bind()` + `.run()` + `.await`:

- `#[actix_web::main]` sustituye a `#[tokio::main]` (azúcar sobre `actix-rt`).
- `HttpServer::new` recibe una **factory** (closure que devuelve una `App` nueva por cada worker), no una `App` ya creada.
- `.bind()` devuelve `Result`; el `?` funciona porque `main` devuelve `std::io::Result<()>`.

```rust
use actix_web::{web, App, HttpServer, Responder};

async fn raiz() -> impl Responder {
    "¡Hola desde Actix-web!"
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().route("/", web::get().to(raiz)))
        .bind(("127.0.0.1", 3000))?
        .run()
        .await
}
```

#### App, web::get, HttpServer y web::Data

El registro de rutas es declarativo: `web::get()`, `web::post()`, etc., devuelven un *route guard* que `.to(handler)` conecta al handler. El estado se registra con `.app_data(web::Data::new(...))` y se extrae con `web::Data<T>`. `web::Data<T>` envuelve un `Arc<T>`: clonarlo es barato y cada worker recibe su copia del `Arc` (por eso la factory debe ser `move` y clonar el `Data`):

```rust
use std::sync::Mutex;
use actix_web::{web, App, HttpServer, Responder};

struct Contador {
    n: Mutex<u64>,
}

async fn cuenta(data: web::Data<Contador>) -> impl Responder {
    let mut n = data.n.lock().unwrap();
    *n += 1;
    format!("Visita número {}", *n)
}
```

El registro del `Data` en la app: `let c = web::Data::new(Contador { n: Mutex::new(0) });` y luego `HttpServer::new(move || App::new().app_data(c.clone()).route("/", web::get().to(cuenta)))`.

#### Handlers con impl Responder y web::Json

El trait `Responder` es el análogo de `IntoResponse`. Lo implementan `&'static str`, `String`, `HttpResponse`, `Json<T>`, `Result<T, E>` (si `T: Responder`), etc. Para errores, `HttpResponse` ofrece constructores por estado (`HttpResponse::NotFound()`, `HttpResponse::BadRequest()`, ...). `web::Json<T>` extrae el cuerpo como `T` (devuelve `400` si falla) y `.json(valor)` serializa cualquier tipo `Serialize`. Los extractores de Actix-web se combinan como argumentos en cualquier orden, pero **solo puede haber un extractor de cuerpo** (`web::Json`, `web::Form`, `web::Bytes`) y debe ir el último:

```rust
use actix_web::{web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct Usuario {
    id: u32,
    nombre: String,
}

async fn crear_usuario(datos: web::Json<Usuario>) -> impl Responder {
    HttpResponse::Created().json(datos.into_inner())
}

async fn ver_usuario(web::Path(id): web::Path<u32>) -> impl Responder {
    HttpResponse::Ok().json(Usuario { id, nombre: format!("usuario_{id}") })
}
```

### Middleware en Axum

#### tower-http: trace, cors, compression

`tower-http` reúne middlewares reutilizables para el ecosistema Tower:

```rust
use axum::{http::StatusCode, response::IntoResponse, routing::get, Router};
use tower_http::{
    compression::CompressionLayer,
    cors::CorsLayer,
    trace::TraceLayer,
};

async fn no_encontrado() -> impl IntoResponse {
    (StatusCode::NOT_FOUND, "Recurso no encontrado")
}

fn app() -> Router {
    Router::new()
        .route("/", get(|| async { "ok" }))
        .layer(TraceLayer::new_for_http())   // logs de peticiones (requiere tracing_subscriber)
        .layer(CorsLayer::permissive())      // CORS abierto (solo desarrollo)
        .layer(CompressionLayer::new())      // gzip/br en respuestas
        .fallback(no_encontrado)
}
```

- `TraceLayer::new_for_http()` registra cada petición con `tracing` (método, URI, latencia, status).
- `CorsLayer` gestiona `Access-Control-Allow-*`; en producción usa `allow_origin(...)`/`allow_methods(...)`.
- `CompressionLayer::new()` comprime según el `Accept-Encoding` del cliente.

#### Capas (layer) y fallback

Las capas se aplican con `.layer(...)` y **el orden importa**: se envuelven de fuera hacia dentro; registra CORS/trace en el router raíz para cubrir todas las rutas. El `fallback` es el handler que se ejecuta cuando **ninguna** ruta coincide. Trampa clásica: `.fallback(...)` registrado **después** de `.layer(...)` puede no quedar cubierto por esa capa, así que regístralo antes de los middlewares.

### Testing de handlers

El `Router` de Axum es un `tower::Service`, así que se puede probar **sin levantar un servidor**: se envía una `Request` con `oneshot` y se recibe la `Response`. Se necesita `tower` como dependencia de desarrollo (`tower = { version = "0.5", features = ["util"] }` y `http-body-util = "0.1"`). `oneshot` consume el servicio, por eso se construye el `Router` dentro de cada test; para rutas con estado, usa `.with_state(...)` en la función de test:

```rust
use axum::{body::Body, http::{Request, StatusCode}, routing::get, Router};
use http_body_util::BodyExt;
use tower::ServiceExt; // oneshot

#[tokio::test]
async fn raiz_responde_200() {
    let respuesta = Router::new()
        .route("/", get(|| async { "hola" }))
        .oneshot(Request::builder().uri("/").body(Body::empty()).unwrap())
        .await
        .unwrap();

    assert_eq!(respuesta.status(), StatusCode::OK);

    let cuerpo = respuesta.into_body().collect().await.unwrap().to_bytes();
    assert_eq!(&cuerpo[..], b"hola");
}
```

### Despliegue

#### Compilar con release, bind a 0.0.0.0

```bash
cargo build --release
./target/release/mi_backend
```

El bind de desarrollo usa `127.0.0.1` (solo máquina local); en producción hay que escuchar en **todas** las interfaces para que un proxy inverso (Nginx/Caddy) pueda reenviarte el tráfico:

```rust
// Desarrollo (solo local):     // Producción (tras el proxy):
tokio::net::TcpListener::bind("127.0.0.1:3000")   // bind("0.0.0.0:3000")
```

Conviene leer host y puerto de variables de entorno (`std::env::var`) para no recompilar por despliegue. En Actix-web el equivalente es `.bind(("0.0.0.0", 8080))`. El proxy inverso suele encargarse del TLS, así que el binario habla HTTP plano.

## Ejemplos de código

### Ejemplo 1 — CRUD en memoria con Axum

Mini API de "repositorios" (listar, crear, ver, borrar) con `Arc<Mutex<HashMap>>` y `tower-http`. Dependencias: las del `cargo add` de arriba (axum 0.8, tokio 1 con `full`, serde 1 con `derive`, serde_json 1, tower-http 0.6 con `cors,trace`, tracing y tracing-subscriber).

```rust
// src/main.rs
use std::collections::HashMap;
use std::sync::{Arc, Mutex};

use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::IntoResponse,
    routing::{delete, get, post},
    Json, Router,
};
use serde::{Deserialize, Serialize};

#[derive(Clone)]
struct AppState {
    repos: Arc<Mutex<HashMap<u32, String>>>,
}

#[derive(Serialize)]
struct Repo {
    id: u32,
    nombre: String,
}

#[derive(Deserialize)]
struct NuevoRepo {
    nombre: String,
}

type ApiError = (StatusCode, String);

async fn listar_repos(State(state): State<AppState>) -> Json<Vec<Repo>> {
    let repos = state.repos.lock().unwrap();
    let lista = repos
        .iter()
        .map(|(id, nombre)| Repo { id: *id, nombre: nombre.clone() })
        .collect();
    Json(lista)
}

async fn ver_repo(
    State(state): State<AppState>,
    Path(id): Path<u32>,
) -> Result<Json<Repo>, ApiError> {
    let repos = state.repos.lock().unwrap();
    match repos.get(&id) {
        Some(nombre) => Ok(Json(Repo { id, nombre: nombre.clone() })),
        None => Err((StatusCode::NOT_FOUND, format!("El repo {id} no existe"))),
    }
}

async fn crear_repo(
    State(state): State<AppState>,
    Json(payload): Json<NuevoRepo>,
) -> impl IntoResponse {
    if payload.nombre.trim().is_empty() {
        return (StatusCode::BAD_REQUEST, "El nombre no puede estar vacío").into_response();
    }

    let nuevo_id = {
        let mut repos = state.repos.lock().unwrap();
        let nuevo_id = repos.keys().max().copied().unwrap_or(0) + 1;
        repos.insert(nuevo_id, payload.nombre.trim().to_string());
        nuevo_id
    };

    (StatusCode::CREATED, Json(Repo { id: nuevo_id, nombre: payload.nombre })).into_response()
}

async fn borrar_repo(
    State(state): State<AppState>,
    Path(id): Path<u32>,
) -> Result<StatusCode, ApiError> {
    let mut repos = state.repos.lock().unwrap();
    match repos.remove(&id) {
        Some(_) => Ok(StatusCode::NO_CONTENT),
        None => Err((StatusCode::NOT_FOUND, format!("El repo {id} no existe"))),
    }
}

fn app() -> Router {
    let state = AppState {
        repos: Arc::new(Mutex::new(HashMap::new())),
    };

    Router::new()
        .route("/repos", get(listar_repos).post(crear_repo))
        .route("/repos/{id}", get(ver_repo).delete(borrar_repo))
        .with_state(state)
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000").await.unwrap();
    println!("API escuchando en http://127.0.0.1:3000");

    axum::serve(listener, app().layer(tower_http::trace::TraceLayer::new_for_http()))
        .await
        .unwrap();
}
```

Prueba rápida con curl: `curl -X POST localhost:3000/repos -H 'Content-Type: application/json' -d '{"nombre":"mi-api"}'` y luego `curl localhost:3000/repos`, `curl localhost:3000/repos/1`, `curl -X DELETE localhost:3000/repos/1`.

### Ejemplo 2 — CRUD mínimo con Actix-web

El equivalente en Actix-web, con `web::Data` como estado compartido. Dependencias: `actix-web = "4"`, `serde = { version = "1", features = ["derive"] }`, `serde_json = "1"`.

```rust
// src/main.rs
use std::collections::HashMap;
use std::sync::Mutex;

use actix_web::{web, App, HttpResponse, HttpServer, Responder};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct Repo {
    id: u32,
    nombre: String,
}

struct AppState {
    repos: Mutex<HashMap<u32, String>>,
}

async fn listar_repos(data: web::Data<AppState>) -> impl Responder {
    let repos = data.repos.lock().unwrap();
    let lista: Vec<Repo> = repos
        .iter()
        .map(|(id, nombre)| Repo { id: *id, nombre: nombre.clone() })
        .collect();
    HttpResponse::Ok().json(lista)
}

async fn ver_repo(data: web::Data<AppState>, web::Path(id): web::Path<u32>) -> impl Responder {
    let repos = data.repos.lock().unwrap();
    match repos.get(&id) {
        Some(nombre) => HttpResponse::Ok().json(Repo { id, nombre: nombre.clone() }),
        None => HttpResponse::NotFound().body(format!("El repo {id} no existe")),
    }
}

async fn crear_repo(data: web::Data<AppState>, repo: web::Json<Repo>) -> impl Responder {
    let mut repos = data.repos.lock().unwrap();
    let id = repos.keys().max().copied().unwrap_or(0) + 1;
    repos.insert(id, repo.nombre.clone());
    HttpResponse::Created().json(Repo { id, nombre: repo.nombre.clone() })
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let estado = web::Data::new(AppState {
        repos: Mutex::new(HashMap::new()),
    });

    HttpServer::new(move || {
        App::new()
            .app_data(estado.clone())
            .route("/repos", web::get().to(listar_repos))
            .route("/repos", web::post().to(crear_repo))
            .route("/repos/{id}", web::get().to(ver_repo))
    })
    .bind(("127.0.0.1", 3000))?
    .run()
    .await
}
```

### Ejemplo 3 — Testing de handlers de Axum con tower::oneshot

Añade a `Cargo.toml` (`dev-dependencies`) `tower = { version = "0.5", features = ["util"] }` y `http-body-util = "0.1"`. Para que los tests importen `app`, el binario debe exponerla como biblioteca (crea `src/lib.rs` con `pub fn app() -> Router`) o coloca los tests en un módulo `#[cfg(test)]`. Como `oneshot` consume el servicio, cada test crea su propia app (y su propio estado):

```rust
// tests/api.rs
use api_repos::app;
use axum::{body::Body, http::{Request, StatusCode}};
use http_body_util::BodyExt;
use serde_json::json;
use tower::ServiceExt;

#[tokio::test]
async fn crear_y_listar_repos() {
    let mut servicio = app();

    let respuesta = servicio
        .oneshot(
            Request::builder()
                .method("POST")
                .uri("/repos")
                .header("content-type", "application/json")
                .body(Body::from(json!({"nombre": "cargo-web"}).to_string()))
                .unwrap(),
        )
        .await
        .unwrap();
    assert_eq!(respuesta.status(), StatusCode::CREATED);

    let respuesta = servicio
        .oneshot(Request::builder().uri("/repos").body(Body::empty()).unwrap())
        .await
        .unwrap();
    assert_eq!(respuesta.status(), StatusCode::OK);

    let cuerpo = respuesta.into_body().collect().await.unwrap().to_bytes();
    assert!(String::from_utf8_lossy(&cuerpo).contains("cargo-web"));
}

#[tokio::test]
async fn ver_repo_inexistente_devuelve_404() {
    let respuesta = app()
        .oneshot(Request::builder().uri("/repos/999").body(Body::empty()).unwrap())
        .await
        .unwrap();

    assert_eq!(respuesta.status(), StatusCode::NOT_FOUND);
}
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — Experto](../ejercicios/nivel-05-experto/)

## Errores comunes

| # | Error | Mensaje | Explicación y solución |
|---|---|---|---|
| 1 | **Ruta con `/:id` en Axum 0.8** | *runtime:* `404` o `invalid route` | Axum 0.7+ usa llaves: `/{id}`. El formato `:id` ya no se admite. |
| 2 | **Handler que no devuelve `IntoResponse`** | `E0277` — `the trait bound `MyType: IntoResponse` is not satisfied` | El retorno debe implementar `IntoResponse`. Envuelve en `Json(...)`, `String` o implementa el trait. |
| 3 | **Dos extractores de cuerpo en un handler** | `E0277` o *runtime:* `400` | Solo puede haber un extractor de cuerpo (`Json`, `Bytes`...). En Actix-web debe ir el último argumento. |
| 4 | **Olvidar `.with_state(...)`** | *runtime:* `Missing request extension` | El router usa `State<T>` pero nunca se registró el estado. Llama `.with_state(mi_estado)` en el router raíz. |
| 5 | **`AppState` sin `Clone`** | `E0277` — `the trait bound `AppState: Clone` is not satisfied` | `State<T>` clona el estado por ti; tu struct debe ser `Clone`. Con `Arc<Mutex<T>>` dentro, el derive funciona. |
| 6 | **`?` en `main` sin `Result`** | `E0277` — `the `?` operator can only be used in a function that returns `Result` or `Option`` | En Actix-web usa `async fn main() -> std::io::Result<()>`; en Axum haz `.await.unwrap()` sobre `axum::serve(...)`. |
| 7 | **`web::Data` no clonada en la factory de `HttpServer`** | `E0382` — `use of moved value: `estado`` | La closure de `HttpServer::new` es `move` y se invoca por cada worker. Clona el `Data` dentro: `.app_data(estado.clone())`. |
| 8 | **`MutexGuard` que cruza `.await`** | `E0515` o *runtime:* bloqueo/deadlock | No mantengas `lock()` cruzando `.await`. Suelta la guardia (bloque) o usa `tokio::sync::Mutex`. |
| 9 | **`oneshot` consume el servicio** | `E0382` — `use of moved value: `app`` | `ServiceExt::oneshot` toma el servicio por valor. Construye el `Router` dentro de cada test. |
| 10 | **JSON con campos que no matchean el struct** | *runtime:* `400 Bad Request` | El extractor `Json<T>`/`web::Json<T>` falla si falta un campo obligatorio o el tipo no coincide. Usa `Option<T>` para campos opcionales. |

## Recursos

- [Axum — documentación oficial](https://docs.rs/axum/latest/axum/)
- [Axum — GitHub (ejemplos)](https://github.com/tokio-rs/axum/tree/main/examples)
- [Actix-web — sitio oficial](https://actix.rs/)
- [Actix-web — docs.rs](https://docs.rs/actix-web/latest/actix_web/)
- [Tokio — documentación oficial](https://tokio.rs/)
- [tower-http — documentación](https://docs.rs/tower-http/latest/tower_http/)
- [tower — crate (Service y ServiceExt)](https://docs.rs/tower/latest/tower/)
- [The Rust Book — Capítulo 20: servidor web con TCP](https://doc.rust-lang.org/book/ch20-00-final-project-a-web-server.html)
- [Serde — documentación](https://serde.rs/)