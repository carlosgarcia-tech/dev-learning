const { GraphQLError } = require('graphql');

const resolvers = {
  Mutation: {
    deletePost: async (parent, args, context) => {
      if (!context.user) {
        throw new GraphQLError('Debes iniciar sesión', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      if (!context.user.isAdmin) {
        throw new GraphQLError('No autorizado para borrar posts', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      await context.db.posts.delete({ id: args.id });
      return true;
    },
  },
};

module.exports = { resolvers };
