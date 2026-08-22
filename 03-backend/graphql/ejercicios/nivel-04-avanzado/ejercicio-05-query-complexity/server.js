const { ApolloServer } = require('@apollo/server');
const depthLimit = require('graphql-depth-limit').default;
const {
  createComplexityRule,
  simpleEstimator,
  fieldExtensionsEstimator,
} = require('graphql-query-complexity');

const typeDefs = require('./schema.graphql');
const resolvers = require('./resolvers.js');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [
    depthLimit(7), // máximo 7 niveles de profundidad
    (requestContext) =>
      createComplexityRule({
        maximumComplexity: 1000,
        variables: requestContext.request.variables,
        estimators: [
          fieldExtensionsEstimator(),
          simpleEstimator({ defaultComplexity: 1 }),
        ],
        onComplete: (complexity) => {
          console.log('Query complexity:', complexity);
        },
      }),
  ],
});

module.exports = { server };
