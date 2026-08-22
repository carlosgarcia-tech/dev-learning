const { SchemaDirectiveVisitor } = require('@graphql/tools/utils');
const { GraphQLError } = require('graphql');

function hasRole(user, role) {
  if (!user) return false;
  if (role === 'USER') return true;
  return user.role === 'ADMIN';
}

class AuthDirective extends SchemaDirectiveVisitor {
  visitFieldDefinition(field) {
    const requiredRole = this.args.requires;
    const originalResolver = field.resolve;

    field.resolve = async (parent, args, context, info) => {
      if (!context.user) {
        throw new GraphQLError('No autenticado', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      if (!hasRole(context.user, requiredRole)) {
        throw new GraphQLError('No autorizado', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      return originalResolver
        ? originalResolver(parent, args, context, info)
        : parent[field.name];
    };
  }
}

module.exports = { AuthDirective, hasRole };
