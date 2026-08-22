const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const SECRET = process.env.JWT_SECRET || 'dev-secret';

const users = [
  { id: '1', email: 'ana@x.com', name: 'Ana', passwordHash: '$2a$10$...' },
];

const resolvers = {
  Query: {
    hello: () => '¡Hola desde Apollo Server!',
    me: (parent, args, context) => context.user,
  },
  Mutation: {
    login: async (parent, { email, password }) => {
      const user = users.find((u) => u.email === email);
      if (!user) throw new Error('Usuario no encontrado');
      const valid = await bcrypt.compare(password, user.passwordHash);
      if (!valid) throw new Error('Contraseña incorrecta');
      const token = jwt.sign({ userId: user.id }, SECRET, { expiresIn: '1d' });
      return { token, user: { id: user.id, email: user.email, name: user.name } };
    },
  },
};

module.exports = { resolvers };
