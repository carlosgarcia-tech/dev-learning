import { createApp } from "./app";
import { env } from "./config/env";
import { logger } from "./config/logger";

const app = createApp();

app.listen(env.port, () => {
    logger.info(`Servidor escuchando en http://localhost:${env.port}`);
});
