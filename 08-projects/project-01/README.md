# Proyecto 01: App CLI de gestión de tareas

Proyecto integrador de **nivel inicial**. Construye una aplicación de línea de comandos (CLI) para gestionar tareas con persistencia en JSON, comandos CRUD, filtros y exportación.

---

## Contexto

Hasta ahora has estudiado la sintaxis de un lenguaje, control de flujo, funciones, estructuras de datos y entrada/salida. Este proyecto te reta a **integrar todo eso** en una aplicación real que se ejecuta en la terminal y que, aunque simple, tiene la estructura de un programa completo: argumentos, lógica de negocio, persistencia, filtros y salida formateada.

Es el puente entre "hacer ejercicios sueltos" y "construir software".

### ¿Qué construirás?

Una herramienta tipo `todo` que se invoca así:

```bash
node tasks.js add "Comprar pan" --priority high
node tasks.js list --status pending
node tasks.js done 3
node tasks.js export tasks.csv
```

### Lenguaje

Puedes hacerlo en **Python** o **Node.js** (elige el que estés estudiando). Los requisitos y la estructura son los mismos.

### Tiempo estimado

8-15 horas según experiencia.

---

## Requisitos técnicos

### Stack

- **Python 3.10+** (con `argparse` o `click`) **o** **Node.js 20+** (con `commander` o sin librerías).
- Persistencia en archivo **JSON** (sin base de datos).
- Sin frameworks externos para la lógica de negocio (solo para CLI si quieres).

### Entregables

- Repositorio git con historial limpio (commits por feature).
- Ejecutable `tasks.js` (o `tasks.py`) funcional desde la terminal.
- Archivo `tasks.json` que se crea automáticamente al añadir la primera tarea.
- `README.md` con instrucciones de uso (puedes basarte en este).
- `.gitignore` que ignore `tasks.json` si quieres testear limpio.

---

## Modelo de datos

Cada tarea es un objeto con esta forma:

```json
{
  "id": 1,
  "title": "Comprar pan",
  "description": "Integral de centeno",
  "priority": "high",
  "status": "pending",
  "tags": ["compra", "casa"],
  "createdAt": "2025-08-22T10:00:00Z",
  "completedAt": null
}
```

- `id`: entero autoincremental.
- `title`: string, obligatorio.
- `description`: string, opcional.
- `priority`: enum `low` | `medium` | `high` (por defecto `medium`).
- `status`: enum `pending` | `in-progress` | `done` (por defecto `pending`).
- `tags`: array de strings, opcional.
- `createdAt`: ISO 8601, automático.
- `completedAt`: ISO 8601 o `null`.

El archivo `tasks.json` guarda un array de estas tareas:

```json
[
  { "id": 1, ... },
  { "id": 2, ... }
]
```

---

## Comandos (CRUD + filtros + exportación)

### 1. `add` — crear tarea

```bash
node tasks.js add "Comprar pan" --priority high --tags compra,casa
node tasks.js add "Estudiar SQL" --description "Capítulo de JOINs"
```

- `title` es obligatorio (argumento posicional).
- `--priority` opcional (default `medium`).
- `--description` opcional.
- `--tags` opcional, separadas por coma.
- Imprime el ID asignado.

### 2. `list` — listar y filtrar

```bash
node tasks.js list
node tasks.js list --status pending
node tasks.js list --priority high
node tasks.js list --tag compra
node tasks.js list --sort priority
node tasks.js list --sort date
```

- Sin argumentos: lista todas.
- `--status <valor>`: filtra por estado.
- `--priority <valor>`: filtra por prioridad.
- `--tag <valor>`: filtra por etiqueta.
- `--sort priority|date`: ordena por prioridad (high→low) o fecha (más reciente primero).

Salida formateada en tabla:

```
ID  ESTADO    PRIORIDAD  TÍTULO             TAGS
1   pending   high       Comprar pan        compra, casa
2   done      low        Estudiar SQL       estudio
```

### 3. `update` — actualizar

```bash
node tasks.js update 3 --title "Nuevo título"
node tasks.js update 3 --priority low
node tasks.js update 3 --status in-progress
```

- El ID es obligatorio.
- Al menos una de las flags `--title`, `--description`, `--priority`, `--status`, `--tags`.
- Si `status` pasa a `done`, setear `completedAt`.

### 4. `delete` — borrar

```bash
node tasks.js delete 3
```

- Elimina la tarea con ese ID.
- Si no existe, error claro (no crash).

### 5. `done` — marcar como completada

```bash
node tasks.js done 3
```

- Atajo para `update 3 --status done`.
- Setea `completedAt` a ahora.

### 6. `clear` — borrar varias

```bash
node tasks.js clear --status done
node tasks.js clear --priority low
```

- Borra todas las que cumplan el filtro.

### 7. `export` — exportar

```bash
node tasks.js export tasks.csv
node tasks.js export tasks.md
node tasks.js export tasks.json
```

- `.csv`: columnas `id,title,priority,status,tags,createdAt`.
- `.md`: tabla Markdown.
- `.json`: copia del archivo.
- Si el archivo existe, sobrescribe (con warning).

---

## Fases del proyecto

### Fase 0: Preparación

1. Crea un repo git nuevo.
2. Inicializa el proyecto (`npm init -y` o `python -m venv venv`).
3. Crea el archivo principal: `tasks.js` (Node) o `tasks.py` (Python).
4. Crea un `.gitignore` que ignore `node_modules/` (Node) o `__pycache__/` (Python).
5. Primer commit: "Initial commit".

### Fase 1: Estructura y argumentos

1. Define la función `main()` que lea `process.argv` (Node) o `sys.argv` (Python).
2. Reconoce el subcomando: `add`, `list`, `update`, `delete`, `done`, `clear`, `export`.
3. Si no hay subcomando o es `--help`, imprime ayuda.
4. Commit: "feat: parseo de argumentos básico".

### Fase 2: Persistencia JSON

1. Función `loadTasks()`: lee `tasks.json`. Si no existe, devuelve `[]`.
2. Función `saveTasks(tasks)`: escribe el array en `tasks.json` (con formato indentado).
3. Maneja errores: archivo corrupto, permisos.
4. Commit: "feat: persistencia en JSON".

### Fase 3: Comando `add`

1. Lee el título (argumento posicional).
2. Genera un ID (máximo ID existente + 1).
3. Genera `createdAt` con la fecha actual en ISO.
4. Añade al array y guarda.
5. Imprime: `Tarea creada con ID: 5`.
6. Commit: "feat: comando add".

### Fase 4: Comando `list` sin filtros

1. Lee todas las tareas.
2. Imprime la tabla formateada (alinea columnas).
3. Si no hay tareas: "No hay tareas. Usa 'add' para crear una."
4. Commit: "feat: comando list básico".

### Fase 5: Filtros y orden

1. Añade `--status`, `--priority`, `--tag`.
2. Añade `--sort priority|date`.
3. Implementa la lógica de filtrado y ordenación.
4. Commit: "feat: filtros y orden en list".

### Fase 6: Comandos `update`, `delete`, `done`, `clear`

1. `update`: busca por ID, aplica cambios, guarda.
2. `delete`: filtra quitando el ID, guarda.
3. `done`: atajo de update.
4. `clear`: borra por filtro.
5. Maneja el caso "ID no encontrado" con mensaje claro.
6. Commit: "feat: update, delete, done y clear".

### Fase 7: Comando `export`

1. Detecta la extensión (`.csv`, `.md`, `.json`).
2. Genera el contenido en el formato correcto.
3. Escribe el archivo.
4. Si existe, pregunta confirmación (o sobrescribe con warning).
5. Commit: "feat: exportación a csv/md/json".

### Fase 8: Pulido y errores

1. Valida entradas: priority solo `low|medium|high`, status solo `pending|in-progress|done`.
2. Mensajes de error claros con código de salida no cero.
3. Ayuda `--help` para cada subcomando.
4. Color opcional en la salida (verde para done, amarillo para pending).
5. Commit: "feat: validación y ayuda".

### Fase 9: Tests manuales

Prueba estos escenarios:

- Añadir 5 tareas con distintas prioridades.
- Listar pendientes.
- Marcar 2 como done.
- Listar por prioridad high.
- Borrar una.
- Exportar a CSV y verificar el contenido.
- Borrar todas las `done`.
- Listar (quedan las pendientes).
- Commit: "test: escenarios manuales completos".

### Fase 10: README

Escribe un `README.md` con:

- Descripción del proyecto.
- Cómo ejecutarlo.
- Lista de comandos con ejemplos.
- Estructura del JSON.
- Decisiones de diseño.

---

## Estructura del proyecto

```
tasks-cli/
├── tasks.js              # (o tasks.py) entrypoint
├── tasks.json            # datos (se crea solo, en .gitignore opcional)
├── package.json          # (Node) o requirements.txt (Python)
├── README.md
└── .gitignore
```

Si quieres modularizar (recomendado a partir de Fase 6):

```
tasks-cli/
├── tasks.js              # entrypoint: lee argv y llama a commands
├── src/
│   ├── commands.js       # add, list, update, delete, done, clear, export
│   ├── storage.js        # loadTasks, saveTasks
│   ├── models.js         # crearTarea, validarPrioridad, etc.
│   └── format.js         # formatear tabla, CSV, Markdown
├── tasks.json
├── package.json
├── README.md
└── .gitignore
```

---

## Criterios de aceptación

Marca cada casilla cuando esté completo:

### Funcionalidad

- [ ] `add` crea una tarea con ID autoincremental y `createdAt`.
- [ ] `add` valida que el título no esté vacío.
- [ ] `add` valida `priority` (solo low/medium/high).
- [ ] `list` sin argumentos muestra todas las tareas.
- [ ] `list --status`, `--priority`, `--tag` filtran correctamente.
- [ ] `list --sort priority|date` ordena.
- [ ] `update` modifica campos por ID.
- [ ] `delete` elimina por ID.
- [ ] `done` marca como completada y setea `completedAt`.
- [ ] `clear --status done` borra las completadas.
- [ ] `export tasks.csv` genera CSV válido.
- [ ] `export tasks.md` genera tabla Markdown.
- [ ] `export tasks.json` copia el archivo.

### Persistencia

- [ ] `tasks.json` se crea si no existe.
- [ ] Los cambios se guardan tras cada operación.
- [ ] Al cerrar y reabrir la terminal, los datos persisten.
- [ ] ID no se duplican ni se reutilizan tras borrar.

### Robustez

- [ ] ID inexistente produce error claro, no crash.
- [ ] `priority` inválida produce error claro.
- [ ] Argumentos mal formados muestran ayuda.
- [ ] Archivo JSON corrupto produce error legible.
- [ ] Código de salida no cero en errores.

### Calidad

- [ ] Commits por feature, con mensajes descriptivos.
- [ ] README con instrucciones claras.
- [ ] Código legible: funciones cortas, nombres claros.
- [ ] Sin duplicación evidente de lógica.
- [ ] `.gitignore` correcto.

### Extras (opcionales)

- [ ] Colores en la salida.
- [ ] Comando `stats` que muestre nº de tareas por estado y prioridad.
- [ ] `list --interactive` con menú numerado.
- [ ] Importación desde CSV.
- [ ] Backup automático antes de sobrescribir.

---

## Ejemplo de sesión completa

```bash
$ node tasks.js add "Comprar pan" --priority high --tags compra
Tarea creada con ID: 1

$ node tasks.js add "Estudiar SQL" --priority medium --tags estudio
Tarea creada con ID: 2

$ node tasks.js add "Llamar al dentista" --priority high
Tarea creada con ID: 3

$ node tasks.js list
ID  ESTADO    PRIORIDAD  TÍTULO              TAGS
1   pending   high       Comprar pan         compra
2   pending   medium     Estudiar SQL        estudio
3   pending   high       Llamar al dentista

$ node tasks.js list --priority high
ID  ESTADO    PRIORIDAD  TÍTULO              TAGS
1   pending   high       Comprar pan         compra
3   pending   high       Llamar al dentista

$ node tasks.js done 1
Tarea 1 marcada como completada.

$ node tasks.js list --status pending
ID  ESTADO    PRIORIDAD  TÍTULO              TAGS
2   pending   medium     Estudiar SQL        estudio
3   pending   high       Llamar al dentista

$ node tasks.js delete 3
Tarea 3 eliminada.

$ node tasks.js export tasks.csv
Exportado a tasks.csv (2 tareas).

$ node tasks.js clear --status done
Borradas 1 tareas con status=done.

$ node tasks.js list
ID  ESTADO    PRIORIDAD  TÍTULO              TAGS
2   pending   medium     Estudiar SQL        estudio
```

---

## Notas pedagógicas

- **No uses una base de datos**: el reto está en gestionar tú el JSON. Bases de datos vendrán en el proyecto 02.
- **No copies una solución entera**: si te atascas, consulta pistas concretas, no el código completo.
- **Comparte tus dudas**: los errores que encuentres son aprendizaje. Anota cómo los resolviste.
- **El `tasks.json` puede estar en `.gitignore`** para que cada clon del repo empiece limpio, o commiteado como ejemplo. Tu decisión.

## Próximos pasos

Al terminar este proyecto tendrás una base sólida para el [Proyecto 02: API REST + base de datos](../project-02/README.md), donde sustituirás el JSON por una base de datos real y expondrás la lógica vía HTTP.
