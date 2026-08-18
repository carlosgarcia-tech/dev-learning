# 06 — React con TypeScript

## Objetivos

- [ ] Tipar componentes funcionales y sus props
- [ ] Tipar hooks (`useState`, `useEffect`, `useReducer`, `useContext`)
- [ ] Tipar eventos del DOM
- [ ] Tipar children y componentes genéricos

## Apuntes

### Props tipadas

```tsx
interface BotonProps {
    texto: string;
    onClick: () => void;
    variante?: "primario" | "secundario";
    disabled?: boolean;
}

function Boton({ texto, onClick, variante = "primario", disabled = false }: BotonProps) {
    return (
        <button className={`btn btn-${variante}`} onClick={onClick} disabled={disabled}>
            {texto}
        </button>
    );
}
```

### useState tipado

```tsx
import { useState } from "react";

interface Usuario {
    id: number;
    nombre: string;
}

function PerfilUsuario() {
    const [usuario, setUsuario] = useState<Usuario | null>(null);
    const [contador, setContador] = useState(0); // inferido como number

    return <div>{usuario ? usuario.nombre : "Sin usuario"}</div>;
}
```

### useEffect y useReducer

```tsx
import { useEffect, useReducer } from "react";

interface Estado {
    contador: number;
}
type Accion = { type: "incrementar" } | { type: "decrementar" } | { type: "reset" };

function reducer(estado: Estado, accion: Accion): Estado {
    switch (accion.type) {
        case "incrementar": return { contador: estado.contador + 1 };
        case "decrementar": return { contador: estado.contador - 1 };
        case "reset": return { contador: 0 };
    }
}

function Contador() {
    const [estado, dispatch] = useReducer(reducer, { contador: 0 });

    useEffect(() => {
        document.title = `Contador: ${estado.contador}`;
    }, [estado.contador]);

    return (
        <button onClick={() => dispatch({ type: "incrementar" })}>
            {estado.contador}
        </button>
    );
}
```

### Eventos y children

```tsx
interface InputProps {
    value: string;
    onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
}

function CampoTexto({ value, onChange }: InputProps) {
    return <input value={value} onChange={onChange} />;
}

interface TarjetaProps {
    titulo: string;
    children: React.ReactNode;
}

function Tarjeta({ titulo, children }: TarjetaProps) {
    return (
        <div className="tarjeta">
            <h2>{titulo}</h2>
            {children}
        </div>
    );
}
```

## Ejercicios Relacionados

- [Nivel 5: Mini Proyecto](./ejercicios/nivel-05-experto/ejercicio-06-mini-proyecto/)

## Recursos

- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
