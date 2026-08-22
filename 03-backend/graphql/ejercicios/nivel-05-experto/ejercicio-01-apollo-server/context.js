const jwt = require('jsonwebtoken');
const SECRET = process.env.JWT_SECRET || 'dev-secret';

const context = async ({ req }) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  let user = null;
  try {
    if (token) user = jwt.verify(token, SECRET);
  } catch {
    user = null;
  }
  return { user };
};

module.exports = { context };
