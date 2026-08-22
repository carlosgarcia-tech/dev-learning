// server.js — Servidor Apollo de la red social con Express, WebSocket y DataLoader.
const express = require('express');
const cors = require('cors');
const http = require('http');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const { makeExecutableSchema } = require('@graphql-tools/schema');
const { WebSocketServer } = require('ws');
const { useServer } = require('graphql-ws/lib/use/ws');

const { typeDefs, resolvers } = require('./resolvers');
const { context } = require('./context');

// Schema ejecutable (compartido entre HTTP y WebSocket)
const schema = makeExecutableSchema({ typeDefs, resolvers });

async function start() {
  const app = express();
  app.use(cors());
  app.use(express.json());

  const httpServer = http.createServer(app);

  // Servidor Apollo (HTTP)
  const server = new ApolloServer({ schema });
  await server.start();
  app.use('/graphql', expressMiddleware(server, { context }));

  // WebSocket para subscriptions
  const wsServer = new WebSocketServer({
    server: httpServer,
    path: '/graphql',
  });
  useServer({ schema, context }, wsServer);

  const PORT = process.env.PORT || 4000;
  httpServer.listen(PORT, () => {
    console.log(`🚀 HTTP en http://localhost:${PORT}/graphql`);
    console.log(`🔔 Subscriptions en ws://localhost:${PORT}/graphql`);
  });
}

start();
