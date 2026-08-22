// context.js — Context de Apollo con autenticación JWT y DataLoaders por petición.
const jwt = require('jsonwebtoken');
const DataLoader = require('dataloader');
const { PubSub } = require('graphql-subscriptions');

const SECRET = process.env.JWT_SECRET || 'dev-secret';
const pubsub = new PubSub();

const db = require('./db');

// Crea un conjunto de DataLoaders por petición para evitar N+1.
function createLoaders() {
  return {
    user: new DataLoader(async (ids) => {
      const users = await db.users.findManyByIds(ids);
      return ids.map((id) => users.find((u) => u.id === String(id)) || null);
    }),
    postsByAuthor: new DataLoader(async (authorIds) => {
      const posts = await db.posts.findManyByAuthorIds(authorIds);
      return authorIds.map((aid) => posts.filter((p) => String(p.authorId) === String(aid)));
    }),
    commentsByPost: new DataLoader(async (postIds) => {
      const comments = await db.comments.findManyByPostIds(postIds);
      return postIds.map((pid) => comments.filter((c) => String(c.postId) === String(pid)));
    }),
    likesByPost: new DataLoader(async (postIds) => {
      const likes = await db.likes.findManyByPostIds(postIds);
      return postIds.map((pid) => likes.filter((l) => String(l.postId) === String(pid)));
    }),
  };
}

const context = async ({ req, connection }) => {
  // Context para subscriptions WebSocket
  if (connection) {
    return { user: connection.context.user, pubsub, loaders: createLoaders() };
  }

  // Context HTTP: extrae el usuario del header Authorization
  const token = req?.headers?.authorization?.replace('Bearer ', '');
  let user = null;
  try {
    if (token) user = jwt.verify(token, SECRET);
  } catch {
    user = null;
  }

  return { user, pubsub, loaders: createLoaders() };
};

module.exports = { context, pubsub, SECRET };
