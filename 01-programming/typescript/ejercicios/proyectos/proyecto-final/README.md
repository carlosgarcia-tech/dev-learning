# Proyecto Final: API de Gestión de Tareas con Express + TypeScript

## Contexto

Desarrollarás una API REST completa para la gestión de tareas utilizando **Express.js** con **TypeScript**. El sistema debe permitir gestionar usuarios, tareas y categorías con un sistema completo de autenticación.

## Tecnologías

- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Lenguaje**: TypeScript
- **Base de datos**: SQLite (con Prisma o TypeORM)
- **Autenticación**: JWT
- **Validación**: Zod
- **Documentación**: Swagger/OpenAPI
- **Testing**: node:test o Vitest
- **Build**: tsc + tsx o esbuild

## Requisitos Funcionales

### 1. Gestión de Usuarios
- [ ] Registrar usuario (nombre, email, contraseña)
- [ ] Login (generación de JWT)
- [ ] Obtener perfil propio
- [ ] Actualizar perfil
- [ ] Cambiar contraseña

### 2. Gestión de Categorías
- [ ] Crear categoría (nombre, descripción, color)
- [ ] Listar categorías (solo del usuario)
- [ ] Obtener categoría por ID
- [ ] Actualizar categoría
- [ ] Eliminar categoría

### 3. Gestión de Tareas
- [ ] Crear tarea (título, descripción, prioridad, fecha_limite, categoría)
- [ ] Listar tareas (con filtros y paginación)
- [ ] Obtener tarea por ID
- [ ] Actualizar tarea
- [ ] Eliminar tarea
- [ ] Cambiar estado (pendiente, en_progreso, completada)
- [ ] Asignar categoría a tarea

### 4. Reglas de Negocio
- [ ] Los usuarios solo pueden ver sus propias tareas
- [ ] Una tarea puede no tener categoría
- [ ] Prioridades: baja, media, alta
- [ ] Estados: pendiente, en_progreso, completada

### 5. Extras
- [ ] Notificaciones por email (simulado)
- [ ] Búsqueda de tareas por texto
- [ ] Estadísticas (tareas por estado, por categoría)
- [ ] Exportar tareas a CSV

## Requisitos No Funcionales

- [ ] API RESTful con buenas prácticas
- [ ] Manejo de errores con middleware global
- [ ] Validación de entrada con Zod
- [ ] Documentación con Swagger
- [ ] Logging con Winston o Pino
- [ ] Tests unitarios e integración
- [ ] Código limpio y organizado
- [ ] Uso de DTOs
- [ ] TypeScript en modo estricto

## Estructura del Proyecto

```
tasks-api/
├── src/
│   ├── index.ts
│   ├── app.ts
│   ├── config/
│   │   ├── database.ts
│   │   ├── env.ts
│   │   └── logger.ts
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   ├── category.controller.ts
│   │   └── task.controller.ts
│   ├── services/
│   │   ├── auth.service.ts
│   │   ├── category.service.ts
│   │   └── task.service.ts
│   ├── repositories/
│   │   ├── user.repository.ts
│   │   ├── category.repository.ts
│   │   └── task.repository.ts
│   ├── models/
│   │   ├── user.model.ts
│   │   ├── category.model.ts
│   │   └── task.model.ts
│   ├── schemas/
│   │   ├── auth.schema.ts
│   │   ├── category.schema.ts
│   │   └── task.schema.ts
│   ├── middlewares/
│   │   ├── auth.middleware.ts
│   │   ├── error.middleware.ts
│   │   └── validation.middleware.ts
│   ├── dtos/
│   │   ├── user.dto.ts
│   │   ├── category.dto.ts
│   │   └── task.dto.ts
│   ├── types/
│   │   ├── express.ts
│   │   └── index.ts
│   └── utils/
│       ├── jwt.ts
│       ├── bcrypt.ts
│       └── date.ts
├── tests/
│   ├── unit/
│   │   ├── services/
│   │   └── schemas/
│   └── integration/
│       ├── auth.test.ts
│       ├── category.test.ts
│       └── task.test.ts
├── prisma/
│   ├── schema.prisma
│   └── seed.ts
├── .env.example
├── .gitignore
├── package.json
├── tsconfig.json
├── nodemon.json
└── README.md
```

Un esqueleto inicial de esta estructura (con archivos stub) está disponible en la
carpeta [`starter/`](./starter/) de este mismo directorio.

## Criterios de Aceptación

1. ✅ El proyecto compila sin errores
2. ✅ La API se ejecuta correctamente
3. ✅ Swagger UI está disponible
4. ✅ Se pueden registrar usuarios
5. ✅ El login genera un JWT válido
6. ✅ Los endpoints protegidos requieren autenticación
7. ✅ Los usuarios solo ven sus propios datos
8. ✅ Se pueden crear categorías
9. ✅ Se pueden crear tareas
10. ✅ Se pueden listar tareas con filtros
11. ✅ La paginación funciona correctamente
12. ✅ Se pueden actualizar tareas
13. ✅ Se pueden eliminar tareas
14. ✅ Las validaciones funcionan correctamente
15. ✅ Los errores se manejan consistentemente
16. ✅ Los tests unitarios cubren los servicios
17. ✅ Los tests de integración cubren los endpoints
18. ✅ El código sigue las convenciones de TypeScript
19. ✅ La documentación del código es adecuada
20. ✅ Los DTOs encapsulan correctamente los datos
21. ✅ El logging registra las operaciones importantes
22. ✅ Las variables de entorno están bien configuradas
23. ✅ El código está tipado correctamente (sin any)
24. ✅ Las relaciones entre entidades funcionan

## Fases de Desarrollo

### Fase 1: Setup (Día 1)
- Inicializar proyecto npm
- Instalar dependencias (express, typescript, prisma, zod, etc.)
- Configurar tsconfig.json
- Configurar ESLint y Prettier
- Configurar Prisma

### Fase 2: Modelos y Schemas (Día 2-3)
- Definir modelos en Prisma
- Crear schemas de validación con Zod
- Crear DTOs
- Configurar base de datos

### Fase 3: Autenticación (Día 3-4)
- Implementar registro y login
- Generación y verificación de JWT
- Middleware de autenticación

### Fase 4: CRUD de Categorías (Día 4-5)
- Implementar CRUD de categorías
- Validaciones de permisos
- Tests de categorías

### Fase 5: CRUD de Tareas (Día 5-6)
- Implementar CRUD de tareas
- Filtros y paginación
- Validaciones de permisos
- Tests de tareas

### Fase 6: Mejoras (Día 6-7)
- Documentación con Swagger
- Logging
- Manejo de errores
- Tests de integración

## Rúbrica de Evaluación

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Funcionalidad | 30% | Todos los endpoints funcionan correctamente |
| Código y Tipado | 25% | Código limpio, tipado fuerte, sin any |
| Tests | 20% | Cobertura de pruebas adecuada |
| Arquitectura | 15% | Buena estructura y separación de responsabilidades |
| Documentación | 10% | Swagger/OpenAPI completo y claro |

## Recursos

- [Express.js Documentation](https://expressjs.com/)
- [TypeScript Documentation](https://www.typescriptlang.org/)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Zod Documentation](https://zod.dev/)
- [JWT.io](https://jwt.io/)
- [Swagger/OpenAPI](https://swagger.io/)
- [node:test Documentation](https://nodejs.org/api/test.html)
