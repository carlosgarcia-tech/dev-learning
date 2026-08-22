const jwt = require('jsonwebtoken');

const SECRET = process.env.JWT_SECRET || 'dev-secret';

function getUserFromToken(token) {
  try {
    if (!token) return null;
    const clean = token.replace('Bearer ', '');
    return jwt.verify(clean, SECRET);
  } catch {
    return null;
  }
}

const context = async ({ req }) => {
  const authHeader = req.headers.authorization || '';
  const user = getUserFromToken(authHeader);
  return { user };
};

module.exports = { context, getUserFromToken };
