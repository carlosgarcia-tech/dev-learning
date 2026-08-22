# 04 — Animaciones y transiciones

> Transitions, transforms, animations, keyframes, cubic-bezier, will-change.

## Objetivos

- [ ] Crear transiciones suaves entre estados
- [ ] Transformar elementos sin afectar el flujo
- [ ] Definir animaciones con `@keyframes`
- [ ] Controlar timing, delay e iteración
- [ ] Usar `cubic-bezier` para curvas personalizadas
- [ ] Optimizar animaciones con `will-change`
- [ ] Saber qué propiedades animar para buen rendimiento

## Transiciones

Las transiciones interpolan suavemente un cambio de valor de una propiedad.

```css
.boton {
  background: #3b82f6;
  color: white;
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  transition: background 0.3s ease, transform 0.2s ease;
}

.boton:hover {
  background: #2563eb;
  transform: translateY(-2px);
}
```

### Propiedades de transition

| Propiedad | Descripción | Ejemplo |
|---|---|---|
| `transition-property` | Qué propiedad animar | `background`, `all` |
| `transition-duration` | Duración | `0.3s` |
| `transition-timing-function` | Curva de tiempo | `ease`, `linear`, `cubic-bezier(...)` |
| `transition-delay` | Retardo | `0.1s` |
| `transition` | Atajo | `background 0.3s ease` |

```css
/* Atajo */
.caja {
  transition: background 0.3s ease 0.1s;
  /*             propiedad duración timing delay */
}
```

```css
/* Múltiples propiedades */
.caja {
  transition:
    background 0.3s ease,
    transform 0.2s ease,
    opacity 0.4s ease;
}
```

## Transformaciones

`transform` modifica un elemento sin afectar el flujo del documento (no empuja a otros).

```css
/* Traslado */
.caja { transform: translate(10px, 20px); }
.caja { transform: translateX(10px); }
.caja { transform: translateY(-50%); }  /* centrado vertical */

/* Rotación */
.caja { transform: rotate(45deg); }

/* Escala */
.caja { transform: scale(1.5); }
.caja { transform: scaleX(2); }
.caja { transform: scale(0.5); }

/* Sesgo */
.casa { transform: skew(10deg, 5deg); }

/* Combinar */
.caja { transform: translate(10px, 0) rotate(5deg) scale(1.1); }
```

### `transform-origin`

Punto desde el que se aplica la transformación.

```css
.caja { transform-origin: center; }      /* default */
.caja { transform-origin: top left; }
.caja { transform-origin: 50% 100%; }    /* abajo centro */
```

### Rotación 3D

```css
.caja { transform: perspective(800px) rotateY(45deg); }
.caja { transform: rotateX(30deg); }
.caja { transform: rotate3d(1, 1, 0, 45deg); }
```

## Animaciones con `@keyframes`

Las animaciones permiten definir fotogramas con valores intermedios, más potentes que las transiciones.

```css
@keyframes rebote {
  0%   { transform: translateY(0); }
  50%  { transform: translateY(-30px); }
  100% { transform: translateY(0); }
}

.pelota {
  animation: rebote 1s ease-in-out infinite;
}
```

### Propiedades de animation

| Propiedad | Descripción | Ejemplo |
|---|---|---|
| `animation-name` | Nombre del `@keyframes` | `rebote` |
| `animation-duration` | Duración | `1s` |
| `animation-timing-function` | Curva | `ease`, `linear` |
| `animation-delay` | Retardo | `0.5s` |
| `animation-iteration-count` | Repeticiones | `infinite`, `3` |
| `animation-direction` | Dirección | `normal`, `reverse`, `alternate` |
| `animation-fill-mode` | Estado antes/después | `forwards`, `backwards`, `both` |
| `animation-play-state` | Pausar/reanudar | `running`, `paused` |
| `animation` | Atajo | `rebote 1s ease infinite` |

```css
.modal {
  animation: aparecer 0.4s ease-out forwards;
}

@keyframes aparecer {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

### `animation-fill-mode`

| Valor | Qué hace |
|---|---|
| `none` (default) | No aplica estilos antes ni después |
| `forwards` | Mantiene el estado final |
| `backwards` | Aplica el estado inicial durante el delay |
| `both` | Ambos |

```css
.caja {
  opacity: 0;
  animation: aparecer 0.5s ease forwards;
  animation-delay: 0.2s;
  /* Durante el delay opacity:0 (backwards), al final opacity:1 (forwards) */
}
```

## Timing functions

| Función | Descripción |
|---|---|
| `ease` (default) | Empieza lento, acelera, termina lento |
| `linear` | Velocidad constante |
| `ease-in` | Empieza lento, acelera |
| `ease-out` | Empieza rápido, frena |
| `ease-in-out` | Lento al principio y al final |
| `cubic-bezier(x1,y1,x2,y2)` | Curva personalizada |
| `steps(n)` | Saltos discretos |

### `cubic-bezier`

Define una curva de tiempo personalizada con dos puntos de control.

```css
.caja { transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55); }  /* rebote */
.caja { transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); }          /* Material */
```

> Sitios como [easings.net](https://easings.net/) y [cubic-bezier.com](https://cubic-bezier.com/) ayudan a visualizar y generar curvas.

## `will-change`

Avisa al navegador de que una propiedad va a cambiar, permitiéndole optimizar.

```css
.card { will-change: transform; }

/* Usar con moderación: solo cuando de verdad va a cambiar */
```

> **Aviso**: `will-change` consume memoria. Úsalo solo en elementos que se van a animar y quítalo cuando terminen. No lo apliques a todo.

## Qué propiedades animar

Para 60 FPS (suave), anima solo propiedades que el navegador pueda manejar en la GPU sin recalcular el layout:

| Animar (barato) | Evitar (caro) |
|---|---|
| `transform` | `width`, `height` |
| `opacity` | `top`, `left`, `right`, `bottom` |
| `filter` | `margin`, `padding` |
| `background-color` | `box-shadow` |

```css
/* Mal: fuerza recálculo de layout */
.caja { transition: width 0.3s; }
.caja:hover { width: 300px; }

/* Bien: transform no recalcula layout */
.caja { transition: transform 0.3s; }
.caja:hover { transform: scaleX(1.5); }
```

## Patrones comunes

### Hover con elevación

```css
.card {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0,0,0,0.15);
}
```

### Fade in al cargar

```css
@keyframes fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}
body { animation: fadeIn 0.5s ease; }
```

### Spinner de carga

```css
@keyframes spin {
  to { transform: rotate(360deg); }
}
.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e5e7eb;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
```

### Pulse

```css
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50%      { opacity: 0.5; }
}
.notificacion {
  animation: pulse 2s ease-in-out infinite;
}
```

### Animación al hacer scroll (con IntersectionObserver)

```css
.revelar {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.revelar.visible {
  opacity: 1;
  transform: translateY(0);
}
```

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach((e) => {
    if (e.isIntersecting) e.target.classList.add('visible');
  });
});
document.querySelectorAll('.revelar').forEach((el) => observer.observe(el));
```

## Respetar `prefers-reduced-motion`

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

> Usuarios sensibles al movimiento pueden tener mareos. Respeta esta preferencia siempre.

## Conceptos clave

- Las transiciones interpolan cambios de estado; las animaciones definen fotogramas.
- `transform` no afecta el flujo del documento: es barato de animar.
- `opacity` y `transform` son las propiedades más eficientes (GPU).
- `cubic-bezier` crea curvas de tiempo personalizadas.
- `will-change` optimiza, pero solo úsalo en elementos que van a animarse.
- `animation-fill-mode: forwards` mantiene el estado final.
- Respeta siempre `prefers-reduced-motion`.

## Errores comunes

- **Animar `width`, `top` o `margin`**: fuerzan recálculo de layout (lag).
- **No usar `transform`**: `top`/`left` son más costosos.
- **`will-change` en todo**: consume memoria y empeora el rendimiento.
- **Olvidar `prefers-reduced-motion`**: molesta a usuarios sensibles.
- **Animaciones demasiado largas**: lentas (>0.5s) parecen lentas, no elegantes.
- **Muchas animaciones simultáneas**: sobrecargan la GPU.
- **No usar `animation-fill-mode`**: el elemento vuelve a su estado inicial al terminar.
- **`transition: all`**: anima propiedades que no quieres y es costoso.
- **Olvidar `transform-origin`**: la rotación no se hace desde el punto esperado.
- **No dar `transition` al quitar el hover**: el cambio de vuelta es instantáneo.
