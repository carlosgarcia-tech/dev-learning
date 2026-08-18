import express, { Application } from "express";
import { errorMiddleware } from "./middlewares/error.middleware";

export function createApp(): Application {
    const app = express();

    app.use(express.json());

    app.get("/health", (_req, res) => {
        res.json({ status: "ok" });
    });

    // TODO: montar routers de auth, categorías y tareas aquí
    // app.use("/api/auth", authRouter);
    // app.use("/api/categories", categoryRouter);
    // app.use("/api/tasks", taskRouter);

    app.use(errorMiddleware);

    return app;
}
