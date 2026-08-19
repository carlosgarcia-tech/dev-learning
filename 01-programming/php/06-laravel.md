# 06 — Laravel

## Objetivos

- [ ] Explicar qué es Laravel y cuándo conviene usarlo frente a PHP puro.
- [ ] Conocer los requisitos técnicos (PHP 8+, Composer, extensiones).
- [ ] Crear un proyecto nuevo con `composer create-project laravel/laravel`.
- [ ] Levantar el servidor de desarrollo con `php artisan serve`.
- [ ] Orientarse en la estructura de carpetas de un proyecto Laravel.
- [ ] Usar `artisan` para generar código: `make:model`, `make:controller`, `make:migration`.
- [ ] Definir rutas GET/POST con parámetros `{id}` y `Route::resource` en `web.php`.
- [ ] Escribir controladores y distinguir los métodos de un controller de recursos.
- [ ] Crear y ejecutar migraciones con `Schema` y `php artisan migrate`.
- [ ] Definir modelos Eloquent y consultarlos desde `tinker`.
- [ ] Maquetar vistas con Blade: `@extends`, `@section`, `@foreach` y `{{ }}`.
- [ ] Proteger formularios con el token CSRF y validar con `$request->validate()`.
- [ ] Restringir rutas con el middleware `auth` y manejar datos de sesión.
- [ ] Montar una API con `php artisan install:api` y `Route::apiResource`.
- [ ] Aplicar buenas prácticas: variables de entorno y despliegue seguro.

## Apuntes

### ¿Qué es Laravel?

[Laravel](https://laravel.com/) es el framework PHP más popular del mundo. Sigue el patrón **MVC** (Modelo-Vista-Controlador) y trae incorporadas todas las piezas que necesitas para una aplicación web real: enrutamiento, ORM, plantillas, autenticación, validación, colas, sesiones y API. Está construido sobre componentes de Symfony. Con PHP puro (como en las guías anteriores) tú escribes el enrutador, el autoload, la capa de base de datos y la seguridad a mano; con Laravel, esas decisiones ya están tomadas por gente experta y probadas en producción.

#### ¿Por qué usar Laravel?

- **Productividad**: `artisan` genera código (modelos, controladores, migraciones) en segundos.
- **Eloquent**: ORM que mapea tablas a objetos PHP con una sintaxis limpia.
- **Blade**: motor de plantillas legible y seguro (escapa la salida automáticamente).
- **Seguridad**: CSRF, validación, password hashing y consultas preparadas por defecto.
- **Ecosistema**: paquetes oficiales para autenticación, API (Sanctum), colas (Horizon) y testing.
- **Comunidad y documentación**: enorme cantidad de tutoriales y soporte.

#### Requisitos

- PHP >= 8.1 (Laravel 10) o >= 8.2 (Laravel 11).
- Composer 2.x.
- Extensiones PHP: `ctype`, `curl`, `dom`, `fileinfo`, `filter`, `hash`, `mbstring`, `openssl`, `pcre`, `pdo`, `session`, `tokenizer` y `xml`.

Verifica el entorno antes de empezar:

```bash
php -v                          # versión de PHP
composer --version              # versión de Composer
php -m | grep -E "mbstring|pdo|openssl|curl|tokenizer|xml"
```

### Instalación

El proyecto se crea con `composer create-project`, que descarga la plantilla de Laravel, instala las dependencias y deja todo listo para arrancar:

```bash
composer create-project laravel/laravel mi-app
cd mi-app
php artisan serve
```

`php artisan serve` levanta un servidor de desarrollo en `http://localhost:8000`; en producción se usa Nginx o Apache apuntando a la carpeta `public/`.

### Estructura de carpetas

Un proyecto Laravel recién creado distribuye el código en carpetas con responsabilidades claras:

| Carpeta | Para qué sirve |
| --- | --- |
| `app/Http/Controllers` | Lógica de respuesta HTTP |
| `app/Models` | Modelos Eloquent que representan tablas |
| `database/migrations` | Definición de esquema (tablas, columnas) |
| `resources/views` | Plantillas Blade |
| `routes` | Definición de rutas (`web.php`, `api.php`) |
| `public` | Única carpeta expuesta al mundo (index.php, assets) |
| `storage` | Logs, caché y archivos generados |
| `vendor` | Dependencias de Composer |

### El comando `artisan`

`artisan` es la interfaz de línea de comandos de Laravel. Se invoca con `php artisan <comando>`:

| Comando | Qué hace |
| --- | --- |
| `php artisan serve` | Levanta el servidor de desarrollo |
| `php artisan make:model Producto` | Crea un modelo Eloquent |
| `php artisan make:controller ProductoController` | Crea un controlador |
| `php artisan make:migration crear_tabla_productos` | Crea una migración |
| `php artisan migrate` | Ejecuta las migraciones pendientes |
| `php artisan tinker` | Consola interactiva de PHP con Eloquent |
| `php artisan route:list` | Muestra todas las rutas registradas (método, URI, controlador y middleware) |

### Rutas

Las rutas web se definen en `routes/web.php`. Cada ruta asocia un método HTTP y una URL con una acción, por ejemplo `Route::get('/', fn () => view('welcome'));` para la página de bienvenida.

#### Rutas GET y POST

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductoController;

Route::get('/productos', [ProductoController::class, 'index']);      // listar
Route::get('/productos/crear', [ProductoController::class, 'create']); // formulario
Route::post('/productos', [ProductoController::class, 'store']);      // guardar
Route::get('/productos/{id}', [ProductoController::class, 'show']);   // ver uno
```

`GET` muestra recursos; `POST` crea o envía datos. La sintaxis `[Clase::class, 'metodo']` apunta al método del controlador, y el parámetro de la ruta (`{id}`) se pasa como argumento a ese método (admite `{id?}` opcional).

#### `Route::resource`

Si el recurso necesita el CRUD completo, `Route::resource` genera las siete rutas REST de una vez:

```php
<?php

use Illuminate\Support\Facades\Route;

Route::resource('productos', ProductoController::class);
```

Equivalentes a las rutas REST: `index` (GET `/productos`), `create` (GET `/productos/create`), `store` (POST `/productos`), `show` (GET `/productos/{producto}`), `edit` (GET `/productos/{producto}/edit`), `update` (PUT/PATCH `/productos/{producto}`) y `destroy` (DELETE `/productos/{producto}`). Las rutas con nombre (`productos.index`, `productos.store`…) permiten generar URLs sin hardcodear con `route('productos.index')`.

### Controladores

Los controladores agrupan la lógica de respuesta de un recurso. Se crean con `php artisan make:controller ProductoController` (con `--resource` se generan los siete métodos ya escritos).

Un controlador de recursos expone los siete métodos del CRUD; cada uno recibe `$request` y/o el parámetro de la ruta, y devuelve una vista o una redirección:

```php
<?php

namespace App\Http\Controllers;

use App\Models\Producto;
use Illuminate\Http\Request;

class ProductoController extends Controller
{
    public function index()                                   // lista: Producto::all()
    {
        return view('productos.index', ['productos' => Producto::all()]);
    }

    public function create()                                  // formulario de alta
    {
        return view('productos.crear');
    }

    public function store(Request $request)                   // guarda un registro
    {
        $producto = Producto::create($request->validate([
            'nombre' => 'required|string|max:100',
            'precio' => 'required|numeric|min:0',
        ]));

        return redirect()->route('productos.index');
    }

    public function show(int $id)                             // ver uno
    {
        return view('productos.mostrar', ['producto' => Producto::findOrFail($id)]);
    }

    public function edit(int $id)                             // formulario de edición
    {
        return view('productos.editar', ['producto' => Producto::findOrFail($id)]);
    }

    public function update(Request $request, int $id)         // actualiza un registro
    {
        $producto = Producto::findOrFail($id);
        $producto->update($request->validate([
            'nombre' => 'required|string|max:100',
            'precio' => 'required|numeric|min:0',
        ]));

        return redirect()->route('productos.index');
    }

    public function destroy(int $id)                          // borra un registro
    {
        Producto::findOrFail($id)->delete();

        return redirect()->route('productos.index');
    }
}
```

### Migraciones y Eloquent

#### Crear una migración

Las migraciones describen el esquema de la base de datos en PHP, versionado en `database/migrations/`:

```bash
php artisan make:migration crear_tabla_productos
```

El archivo generado se edita así:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('productos', function (Blueprint $table) {
            $table->id();
            $table->string('nombre');
            $table->decimal('precio', 10, 2);
            $table->integer('stock')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('productos');
    }
};
```

`up()` crea la tabla; `down()` la deshace. Columnas habituales: `$table->id()`, `string()`, `text()`, `integer()`, `decimal()`, `boolean()`, `foreignId(...)->constrained()` (claves foráneas) y `timestamps()`. Se aplican (o deshacen) con:

```bash
php artisan migrate                # aplica las migraciones pendientes
php artisan migrate:rollback       # deshace la última tanda
php artisan migrate:fresh          # borra todo y vuelve a migrar (¡solo desarrollo!)
```

Por defecto Laravel usa SQLite (archivo `database/database.sqlite`); para MySQL se configura en `.env` con `DB_CONNECTION=mysql`, `DB_HOST`, `DB_DATABASE`, `DB_USERNAME` y `DB_PASSWORD`.

#### Modelos Eloquent

Un modelo representa una tabla. Se crea con `php artisan make:model Producto -m` (el `-m` genera también la migración):

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
    use HasFactory;

    protected $fillable = ['nombre', 'precio', 'stock'];
}
```

`$fillable` lista los campos asignables en masa (seguridad ante *mass assignment*); la convención conecta `Producto` con la tabla `productos`. Los métodos `Producto::all()`, `Producto::find($id)`, `Producto::findOrFail($id)`, `Producto::create($datos)` y `Producto::where(...)` son la puerta de entrada al ORM.

#### Probar con `tinker`

`tinker` es un REPL de PHP con toda la aplicación cargada. Perfecto para probar Eloquent sin escribir tests:

```bash
php artisan tinker
>>> $p = new Producto(['nombre' => 'Laptop', 'precio' => 1200, 'stock' => 5]);
>>> $p->save();
>>> Producto::all();
>>> Producto::where('stock', '>', 0)->get();
>>> exit
```

### Blade

Blade es el motor de plantillas de Laravel. Sus plantillas viven en `resources/views/` con extensión `.blade.php` y usan la sintaxis `@directiva` y `{{ expresión }}`.

#### Layout con `@extends` y `@section`

El layout define la estructura común con `@yield` como huecos; cada vista la extiende y rellena sus secciones:

```blade
{{-- layouts/app.blade.php --}}
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>@yield('titulo', 'Mi tienda')</title></head>
<body>
    <main>@yield('contenido')</main>
</body>
</html>
```

```blade
{{-- productos/index.blade.php --}}
@extends('layouts.app')
@section('titulo', 'Lista de productos')
@section('contenido')
    <h1>Productos</h1>
    <ul>
        @foreach ($productos as $producto)
            <li>{{ $producto->nombre }} — {{ $producto->precio }} €</li>
        @endforeach
    </ul>
@endsection
```

`@extends` indica qué layout usar, `@section`/`@endsection` define el contenido y `@yield` marca el hueco que se rellena. `{{ $var }}` imprime y **escapa** el HTML automáticamente (previene XSS). Otras directivas: `@if/@else`, `@forelse`, `@for`, `@switch` y `@csrf`.

### Formularios y CSRF

Laravel protege los formularios contra ataques **CSRF** (Cross-Site Request Forgery): cada POST debe incluir el token de sesión, que se añade con la directiva `@csrf`:

```blade
{{-- resources/views/productos/crear.blade.php --}}
@extends('layouts.app')

@section('contenido')
    <h1>Nuevo producto</h1>

    <form method="POST" action="{{ route('productos.store') }}">
        @csrf

        <label>Nombre:
            <input type="text" name="nombre" value="{{ old('nombre') }}">
        </label>
        <label>Precio:
            <input type="number" step="0.01" name="precio" value="{{ old('precio') }}">
        </label>

        <button type="submit">Guardar</button>
    </form>
@endsection
```

Sin `@csrf`, Laravel responde con `419 PAGE EXPIRED`. `old('campo')` rellena el valor previo cuando la validación falla.

### Validación

La validación se hace con `$request->validate()`. Si falla, Laravel redirige hacia atrás con los errores, accesibles en Blade con `$errors`:

```php
public function store(Request $request): RedirectResponse
{
    $datos = $request->validate([
        'nombre' => 'required|string|max:100',
        'precio' => 'required|numeric|min:0',
        'stock'  => 'required|integer|min:0',
    ]);

    Producto::create($datos);

    return redirect()->route('productos.index')
                     ->with('ok', 'Producto creado');
}
```

En la vista se muestran los errores, bien todos juntos o por campo:

```blade
@if ($errors->any())
    <ul>
        @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
        @endforeach
    </ul>
@endif
```

Reglas comunes: `required`, `string`, `integer`, `numeric`, `min:X`, `max:X`, `email`, `unique:tabla,columna`, `confirmed` y `date`. La directiva `@error('campo')` muestra el mensaje del error de un campo concreto.

### Middleware de autenticación y sesión

El middleware `auth` exige que el usuario esté logueado antes de acceder a una ruta. Se aplica por ruta o por grupo:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductoController;

// Solo usuarios autenticados
Route::get('/panel', function () {
    return 'Panel privado';
})->middleware('auth');

// Grupo de rutas protegidas
Route::middleware('auth')->group(function () {
    Route::resource('productos', ProductoController::class);
});
```

Los visitantes sin sesión son redirigidos al login (paquetes `laravel/breeze` o `laravel/ui` montan el login completo). La sesión guarda datos por usuario con `$request->session()->get()` / `put()`; por ejemplo, un carrito guarda los IDs en la sesión:

### API con Laravel

Laravel permite exponer JSON con el mismo Eloquent y rutas propias en `routes/api.php`, con prefijo `/api`. Desde Laravel 11 se habilita con `php artisan install:api`, que crea `routes/api.php` y `config/sanctum.php`:

#### `Route::apiResource`

Para un CRUD JSON sin formularios, `apiResource` genera las rutas `index`, `store`, `show`, `update`, `destroy` (omite `create` y `edit`, que no tienen sentido en una API):

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ProductoApiController;

Route::apiResource('productos', ProductoApiController::class);
```

El controlador de API responde con JSON y códigos HTTP: `response()->json($datos, 201)` para crear, `204` para borrar, `404` si `findOrFail` falla. Verás su implementación completa en el Ejemplo 3.

### Buenas prácticas y despliegue

#### Variables de entorno: `.env`

La configuración sensible (BD, claves, correo) va en `.env`, que **nunca se sube** al repositorio. Se versiona solo la plantilla `.env.example`. Al clonar un proyecto:

```bash
cp .env.example .env
php artisan key:generate     # genera APP_KEY (encriptación de sesiones/datos)
```

Nunca despliegues sin `APP_KEY`: las sesiones y datos firmados fallarán.

#### Caché de configuración

En producción, las configuraciones y rutas se cachean para evitar releer y parsear los archivos en cada petición:

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan config:clear     # deshacer la caché (tras cambios en .env)
```

#### Despliegue seguro

```bash
composer install --no-dev --optimize-autoloader   # solo producción, autoloader optimizado
php artisan migrate --force                        # migraciones sin preguntar
php artisan config:cache && php artisan route:cache
# Apuntar el servidor web a public/ y dar permisos de escritura a storage/ y bootstrap/cache/
```

Reglas de oro: el servidor web solo ve `public/`; `.env` nunca en el repositorio; logs y caché fuera de la raíz web; migraciones con `--force`.

## Ejemplos de código

### Ejemplo 1: CRUD completo con rutas, controlador y Blade

`routes/web.php`:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductoController;

Route::get('/', fn () => redirect()->route('productos.index'));

Route::resource('productos', ProductoController::class);
```

`app/Http/Controllers/ProductoController.php`:

```php
<?php

namespace App\Http\Controllers;

use App\Models\Producto;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;

class ProductoController extends Controller
{
    public function index(): View
    {
        return view('productos.index', ['productos' => Producto::all()]);
    }

    public function create(): View
    {
        return view('productos.crear');
    }

    public function store(Request $request): RedirectResponse
    {
        $datos = $request->validate([
            'nombre' => 'required|string|max:100',
            'precio' => 'required|numeric|min:0',
            'stock'  => 'required|integer|min:0',
        ]);

        Producto::create($datos);

        return redirect()->route('productos.index')
                         ->with('ok', 'Producto creado');
    }

    public function destroy(int $id): RedirectResponse
    {
        Producto::findOrFail($id)->delete();

        return redirect()->route('productos.index')
                         ->with('ok', 'Producto eliminado');
    }
}
```

`resources/views/productos/index.blade.php`:

```blade
@extends('layouts.app')

@section('titulo', 'Productos')

@section('contenido')
    @if (session('ok'))
        <p style="color: green">{{ session('ok') }}</p>
    @endif

    <h1>Productos</h1>

    <a href="{{ route('productos.create') }}">Nuevo producto</a>

    <table border="1" cellpadding="6">
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Precio</th>
            <th>Stock</th>
            <th>Acciones</th>
        </tr>
        @forelse ($productos as $producto)
            <tr>
                <td>{{ $producto->id }}</td>
                <td>{{ $producto->nombre }}</td>
                <td>{{ $producto->precio }} €</td>
                <td>{{ $producto->stock }}</td>
                <td>
                    <form method="POST" action="{{ route('productos.destroy', $producto->id) }}">
                        @csrf
                        @method('DELETE')
                        <button type="submit">Eliminar</button>
                    </form>
                </td>
            </tr>
        @empty
            <tr><td colspan="5">No hay productos todavía.</td></tr>
        @endforelse
    </table>
@endsection
```

### Ejemplo 2: formulario con CSRF, validación y errores en Blade

`resources/views/productos/crear.blade.php`:

```blade
@extends('layouts.app')

@section('contenido')
    <h1>Nuevo producto</h1>

    @if ($errors->any())
        <ul style="color: red">
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    @endif

    <form method="POST" action="{{ route('productos.store') }}">
        @csrf

        <p>
            <label>Nombre:</label>
            <input type="text" name="nombre" value="{{ old('nombre') }}">
            @error('nombre') <small style="color: red">{{ $message }}</small> @enderror
        </p>

        <p>
            <label>Precio (€):</label>
            <input type="number" step="0.01" name="precio" value="{{ old('precio') }}">
        </p>

        <button type="submit">Guardar</button>
    </form>
@endsection
```

### Ejemplo 3: API REST con `apiResource`

`routes/api.php`:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ProductoApiController;

Route::apiResource('productos', ProductoApiController::class);
```

`app/Http/Controllers/Api/ProductoApiController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductoApiController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Producto::all());
    }

    public function store(Request $request): JsonResponse
    {
        $datos = $request->validate([
            'nombre' => 'required|string|max:100',
            'precio' => 'required|numeric|min:0',
        ]);

        return response()->json(Producto::create($datos), 201);
    }

    public function show(int $id): JsonResponse
    {
        return response()->json(Producto::findOrFail($id));
    }

    public function destroy(int $id): JsonResponse
    {
        Producto::findOrFail($id)->delete();

        return response()->json(null, 204);
    }
}
```

Probando con `curl`:

```bash
php artisan serve
curl http://localhost:8000/api/productos
curl -X POST http://localhost:8000/api/productos \
     -H "Content-Type: application/json" \
     -d '{"nombre":"Monitor","precio":250.00}'
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — API REST, sesiones y testing](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — MVC y blog con PDO](../ejercicios/nivel-05-experto/)
- [Proyectos PHP](../ejercicios/proyectos/)

## Errores comunes

- **No ejecutar `composer install` tras clonar** → falta `vendor/` y Laravel no arranca. Ejecuta `composer install` y luego `cp .env.example .env` + `php artisan key:generate`.
- **Desplegar sin `APP_KEY`** → sesiones y cookies firmadas fallan con errores de encriptación. Genera la clave con `php artisan key:generate`.
- **Olvidar `@csrf` en un formulario POST** → Laravel responde `419 PAGE EXPIRED`. La directiva `@csrf` es obligatoria en todo `method="POST"`.
- **Usar `{{ }}` para HTML que debe renderizarse** → Blade escapa la salida (seguridad). Si necesitas HTML, usa `{!! !!}` solo con contenido confiable.
- **Asignación masiva sin `$fillable`** → `Producto::create($datos)` ignora silenciosamente los campos o falla. Declara `$fillable` con los campos permitidos.
- **Confundir `Route::get` con `Route::post`** → las rutas que cambian datos (`store`, `update`, `destroy`) son POST/PUT/DELETE; `GET` solo muestra. Una ruta GET que borra datos es un bug de diseño.
- **`findOrFail` vs `find`** → `find()` devuelve `null` si no existe y puede producir "Call to a member function on null". Usa `findOrFail()` para que Laravel responda 404.
- **Ejecutar `migrate:fresh` en producción** → borra todos los datos de la tabla. Solo es seguro en desarrollo; en producción usa `migrate` y migraciones nuevas.
- **Servir la aplicación desde la raíz del proyecto** → se exponen `.env`, `vendor/` y configuraciones. El servidor web debe apuntar a `public/` siempre.
- **Cachear configuración con el `.env` de desarrollo** → tras cambiar `.env`, la caché queda obsoleta. Ejecuta `php artisan config:clear` (o vuelve a `config:cache`).
- **Ignorar `$errors` en las vistas** → tras una validación fallida el usuario ve un formulario vacío sin explicación. Muestra `$errors->all()` o `@error('campo')`.
- **Meter el `id` en el nombre del controlador** → la ruta es `{producto}` pero el método recibe `$id`. No confundas el parámetro de la ruta con el tipo del modelo; si usas route model binding, el parámetro es `Producto $producto`.
- **Dejar `DB_CONNECTION` con SQLite y no crear el archivo** → el error `no such table` es habitual. Crea `database/database.sqlite` o configura MySQL en `.env`.
- **No usar `route()` y hardcodear URLs** → si cambias una URL en `web.php`, todos los `href="/productos"` se rompen. Usa `route('productos.index')`.
- **`Route::resource` con controlador sin métodos** → si el controlador no tiene `index`, `store`, etc., Laravel falla al resolver la ruta. Crea el controlador con `--resource` o escribe los métodos.
- **Confundir `composer install` y `composer update` en despliegues** → `update` cambia versiones; en producción usa `install --no-dev --optimize-autoloader` para reproducir el `composer.lock`.

## Recursos

- [Laravel — Documentación oficial](https://laravel.com/docs)
- [Laravel — Instalación](https://laravel.com/docs/installation)
- [Laravel — Rutas](https://laravel.com/docs/routing)
- [Laravel — Controladores](https://laravel.com/docs/controllers)
- [Laravel — Migraciones](https://laravel.com/docs/migrations)
- [Laravel — Eloquent ORM](https://laravel.com/docs/eloquent)
- [Laravel — Blade](https://laravel.com/docs/blade)
- [Laravel — Validación](https://laravel.com/docs/validation)
- [Laravel — API (Sanctum)](https://laravel.com/docs/sanctum)
- [Laravel — Despliegue](https://laravel.com/docs/deployment)
- [Composer — Documentación](https://getcomposer.org/doc/)