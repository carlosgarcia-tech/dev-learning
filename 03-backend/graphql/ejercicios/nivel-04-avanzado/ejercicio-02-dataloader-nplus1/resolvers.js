const DataLoader = require('dataloader');

function createLoaders(db) {
  const postLoader = new DataLoader(async (userIds) => {
    // UNA sola consulta para todos los userIds (evita N+1)
    const posts = await db.posts.findMany({
      where: { authorId: { in: [...userIds] } },
    });
    // Repartir resultados en el mismo orden que userIds
    return userIds.map((id) => posts.filter((p) => p.authorId === id));
  });

  return { postLoader };
}

const resolvers = {
  Query: {
    users: async (parent, args, context) => {
      return context.db.users.findAll();
    },
  },
  User: {
    posts: (user, args, context) => {
      // Usa el DataLoader en vez de una query por usuario
      return context.loaders.postLoader.load(user.id);
    },
  },
};

module.exports = { resolvers, createLoaders };
