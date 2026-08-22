# 01 — Inicializar un proyecto

## Enunciado

Crea un proyecto Node.js desde cero usando `npm init`.

## Requisitos

1. Crea una carpeta `solucion/`.
2. Ejecuta `npm init -y`.
3. Edita el `package.json` resultante para que tenga:
   - `name`: `mi-proyecto`
   - `version`: `1.0.0`
   - `description`: `Proyecto de aprendizaje`
   - `author`: tu nombre
   - `license`: `MIT`
4. Crea un archivo `index.js` con `console.log("Hola");`.
5. Añade el script `"start": "node index.js"`.

## Pistas

- `npm init -y` genera un `package.json` con valores por defecto.
- Edita el JSON a mano o con `npm config set`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
mkdir -p solucion && cd solucion
npm init -y
# editar package.json
cat > index.js << 'EOF'
console.log("Hola");
EOF
```

`package.json`:

```json
{
  "name": "mi-proyecto",
  "version": "1.0.0",
  "description": "Proyecto de aprendizaje",
  "main": "index.js",
  "scripts": { "start": "node index.js" },
  "author": "Tu Nombre",
  "license": "MIT"
}
```

</details>
