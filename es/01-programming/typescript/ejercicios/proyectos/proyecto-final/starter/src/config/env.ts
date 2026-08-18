import "dotenv/config";

export const env = {
    port: Number(process.env.PORT ?? 3000),
    jwtSecret: process.env.JWT_SECRET ?? "dev-secret",
    jwtExpiresIn: process.env.JWT_EXPIRES_IN ?? "1d",
    databaseUrl: process.env.DATABASE_URL ?? "file:./dev.db"
};
