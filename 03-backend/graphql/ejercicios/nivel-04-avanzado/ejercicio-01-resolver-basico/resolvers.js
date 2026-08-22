const resolvers = {
  Query: {
    user: async (parent, args, context, info) => {
      const user = await context.db.users.findById(args.id);
      return user;
    },
  },
  User: {
    fullName: (user, args, context) => {
      return `${user.firstName} ${user.lastName}`;
    },
  },
};

module.exports = { resolvers };
