const express = require('express');
const cors = require('cors');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const depthLimit = require('graphql-depth-limit').default;
const rateLimit = require('express-rate-limit');

const typeDefs = require('./schema.graphql');
const resolvers = require('./resolvers.js');

const app = express();
app.use(cors());
app.use(express.json());

// Rate limiting: 100 peticiones por minuto por IP
const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 100,
  message: 'Demasiadas peticiones, intenta más tarde',
});

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [depthLimit(10)], // máximo 10 niveles
});

async function start() {
  await server.start();
  app.use('/graphql', limiter, expressMiddleware(server));
  app.listen(4000, () => console.log('🚀 Server en http://localhost:4000/graphql'));
}

start();
