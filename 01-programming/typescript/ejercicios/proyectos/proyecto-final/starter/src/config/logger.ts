type LogLevel = "info" | "warn" | "error";

function log(level: LogLevel, message: string, meta?: Record<string, unknown>): void {
    const timestamp = new Date().toISOString();
    const suffix = meta ? ` ${JSON.stringify(meta)}` : "";
    console.log(`[${timestamp}] [${level.toUpperCase()}] ${message}${suffix}`);
}

export const logger = {
    info: (message: string, meta?: Record<string, unknown>) => log("info", message, meta),
    warn: (message: string, meta?: Record<string, unknown>) => log("warn", message, meta),
    error: (message: string, meta?: Record<string, unknown>) => log("error", message, meta)
};
