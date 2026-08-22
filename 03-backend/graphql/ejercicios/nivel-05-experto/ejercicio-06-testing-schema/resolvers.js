// Resolvers con datos en memoria para testing
const users = [
  { id: '1', name: 'Ana', email: 'ana@x.com' },
  { id: '2', name: 'Luis', email: 'luis@x.com' },
];

const posts = [
  { id: '101', title: 'Hola mundo', authorId: '1' },
];

// rootValue para buildSchema: resolvers por nombre de campo
const rootValue = {
  user: ({ id }) => users.find((u) => u.id === id) || null,
  users: () => users,
  post: ({ id }) => {
    const p = posts.find((p) => p.id === id);
    if (!p) return null;
    return {
      id: p.id,
      title: p.title,
      author: users.find((u) => u.id === p.authorId),
    };
  },
  createUser: ({ name, email }) => {
    const user = { id: String(users.length + 1), name, email };
    users.push(user);
    return user;
  },
  deleteUser: ({ id }) => {
    const idx = users.findIndex((u) => u.id === id);
    if (idx === -1) return false;
    users.splice(idx, 1);
    return true;
  },
};

module.exports = { rootValue, users, posts };
