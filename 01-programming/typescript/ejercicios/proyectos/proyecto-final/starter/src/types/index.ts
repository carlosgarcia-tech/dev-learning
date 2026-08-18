export type Prioridad = "baja" | "media" | "alta";
export type EstadoTarea = "pendiente" | "en_progreso" | "completada";

export interface JwtPayload {
    userId: number;
    email: string;
}
