import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { env } from "../config/env";
import { JwtPayload } from "../types";
import { AppError } from "./error.middleware";

export interface AuthRequest extends Request {
    user?: JwtPayload;
}

export function authMiddleware(req: AuthRequest, _res: Response, next: NextFunction): void {
    const header = req.headers.authorization;
    if (!header?.startsWith("Bearer ")) {
        throw new AppError(401, "Token no proporcionado");
    }

    const token = header.slice("Bearer ".length);

    try {
        const payload = jwt.verify(token, env.jwtSecret) as JwtPayload;
        req.user = payload;
        next();
    } catch {
        throw new AppError(401, "Token inválido o expirado");
    }
}
