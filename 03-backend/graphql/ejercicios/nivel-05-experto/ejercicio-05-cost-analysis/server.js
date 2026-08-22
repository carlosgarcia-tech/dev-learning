const express = require('express');
const cors = require('cors');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const { GraphQLError } = require('graphql');
const { readFileSync } = require('fs');
const costAnalysis = require('graphql-cost-analysis').default;

const typeDefs = readFileSync(require.resolve('./schema.graphql'), 'utf-8');

// Datos de ejemplo en memoria
const users = [
  { id: '1', name: 'Ana' },
  { id: '2', name: 'Luis' },
];
const posts = [
  { id: '101', title: 'Hola mundo', authorId: '1' },
  { id: '102', title: 'Cost analysis', authorId: '1' },
];
const comments = [
  { id: '201', body: 'Genial!', authorId: '2', postId: '101' },
];

const resolvers = {
  Query: {
    user: (_p, { id }) => users.find((u) => u.id === id) || null,
    users: (_p, { limit }) => users.slice(0, limit),
    feed: (_p, { limit }) => posts.slice(0, limit),
  },
  User: {
    posts: (user, { limit }) => posts.filter((p) => p.authorId === user.id).slice(0, limit),
  },
  Post: {
    author: (post) => users.find((u) => u.id === post.authorId),
    comments: (post, { limit }) => comments.filter((c) => c.postId === post.id).slice(0, limit),
  },
  Comment: {
    author: (comment) => users.find((u) => u.id === comment.authorId),
  },
};

// Coste máximo permitido por query
const MAX_COST = 1000;

// Regla de cost analysis: calcula el coste de la query y la rechaza si supera MAX_COST.
function createCostRule(variables = {}) {
  return costAnalysis({
    maximumCost: MAX_COST,
    defaultCost: 1,
    variables,
    createError: (maxCost, cost) =>
      new GraphQLError(`Query rechazada: coste ${cost} supera el máximo ${maxCost}`),
  });
}

const app = express();
app.use(cors());
app.use(express.json());

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: ({ variables }) => [createCostRule(variables)],
});

async function start() {
  await server.start();
  app.use('/graphql', expressMiddleware(server));
  app.listen(4000, () => console.log('🚀 Server en http://localhost:4000/graphql'));
}

start();
