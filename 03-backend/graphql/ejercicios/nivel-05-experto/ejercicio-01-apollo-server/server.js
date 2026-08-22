const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');
const { readFileSync } = require('fs');
const { resolvers } = require('./resolvers');
const { context } = require('./context');

const typeDefs = readFileSync(require.resolve('./schema.graphql'), 'utf-8');

async function start() {
  const server = new ApolloServer({ typeDefs, resolvers });
  const { url } = await startStandaloneServer(server, {
    listen: { port: 4000 },
    context,
  });
  console.log(`🚀 Server en ${url}`);
}

start();
