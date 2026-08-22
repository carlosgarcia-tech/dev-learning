// resolvers.js — Resolvers de la red social con DataLoader.
const { GraphQLError } = require('graphql');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { readFileSync } = require('fs');

const db = require('./db');
const { SECRET, pubsub } = require('./context');

const typeDefs = readFileSync(require.resolve('./schema.graphql'), 'utf-8');

// Helper: exige usuario autenticado en el contexto
function requireAuth(context) {
  if (!context.user) {
    throw new GraphQLError('No autenticado', {
      extensions: { code: 'UNAUTHENTICATED' },
    });
  }
}

// Helper: valida que un email tenga formato correcto
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

const resolvers = {
  DateTime: require('graphql-scalars').DateTimeResolver,

  User: {
    posts: (user, { limit, after }) => db.posts.findByAuthorPaginated(user.id, limit, after),
    followers: (user, { limit }) => db.follows.findFollowers(user.id, limit),
    following: (user, { limit }) => db.follows.findFollowing(user.id, limit),
  },

  Post: {
    author: (post, _args, context) => context.loaders.user.load(post.authorId),
    comments: (post, { limit }) => db.comments.findByPost(post.id, limit),
    likes: (post, _args, context) => context.loaders.likesByPost.load(post.id),
    likeCount: async (post, _args, context) => {
      const likes = await context.loaders.likesByPost.load(post.id);
      return likes.length;
    },
    commentCount: (post) => db.comments.countByPost(post.id),
  },

  Comment: {
    author: (comment, _args, context) => context.loaders.user.load(comment.authorId),
    post: (comment) => db.posts.findById(comment.postId),
  },

  Notification: {
    actor: (notif, _args, context) => context.loaders.user.load(notif.actorId),
  },

  Query: {
    me: (_p, _a, context) => {
      requireAuth(context);
      return db.users.findById(context.user.userId);
    },
    user: (_p, { id }) => db.users.findById(id),
    posts: (_p, { limit, after }) => db.posts.findPaginated(limit, after),
    post: (_p, { id }) => db.posts.findById(id),
    notifications: (_p, _a, context) => {
      requireAuth(context);
      return db.notifications.findByUser(context.user.userId);
    },
  },

  Mutation: {
    register: async (_p, { username, email, password }) => {
      if (!username || username.trim().length < 3) throw new GraphQLError('Username muy corto');
      if (!isValidEmail(email)) throw new GraphQLError('Email inválido');
      if (password.length < 6) throw new GraphQLError('Contraseña muy corta');
      const existing = await db.users.findByEmail(email);
      if (existing) throw new GraphQLError('Email ya registrado');
      const passwordHash = await bcrypt.hash(password, 10);
      const user = await db.users.create({ username, email, passwordHash });
      const token = jwt.sign({ userId: user.id }, SECRET, { expiresIn: '1d' });
      return { token, user };
    },

    login: async (_p, { email, password }) => {
      const user = await db.users.findByEmail(email);
      if (!user) throw new GraphQLError('Credenciales inválidas');
      const valid = await bcrypt.compare(password, user.passwordHash);
      if (!valid) throw new GraphQLError('Credenciales inválidas');
      const token = jwt.sign({ userId: user.id }, SECRET, { expiresIn: '1d' });
      return { token, user };
    },

    createPost: async (_p, { content }, context) => {
      requireAuth(context);
      if (!content || content.trim().length === 0) throw new GraphQLError('Contenido vacío');
      const post = await db.posts.create({ content, authorId: context.user.userId });
      await pubsub.publish('POST_CREATED', { postCreated: post });
      return post;
    },

    createComment: async (_p, { postId, body }, context) => {
      requireAuth(context);
      if (!body || body.trim().length === 0) throw new GraphQLError('Comentario vacío');
      const comment = await db.comments.create({
        postId,
        body,
        authorId: context.user.userId,
      });
      await pubsub.publish('COMMENT_ADDED', { commentAdded: comment });
      return comment;
    },

    toggleLike: async (_p, { postId }, context) => {
      requireAuth(context);
      const liked = await db.likes.toggle({ postId, userId: context.user.userId });
      if (liked) {
        await db.notifications.create({
          type: 'LIKE',
          actorId: context.user.userId,
          postId,
        });
      }
      return db.posts.findById(postId);
    },

    follow: async (_p, { userId }, context) => {
      requireAuth(context);
      await db.follows.follow({ followerId: context.user.userId, followingId: userId });
      await db.notifications.create({
        type: 'FOLLOW',
        actorId: context.user.userId,
        targetId: userId,
      });
      return db.users.findById(userId);
    },

    unfollow: async (_p, { userId }, context) => {
      requireAuth(context);
      await db.follows.unfollow({ followerId: context.user.userId, followingId: userId });
      return db.users.findById(userId);
    },

    markNotificationRead: (_p, { id }, context) => {
      requireAuth(context);
      return db.notifications.markRead(id, context.user.userId);
    },
  },

  Subscription: {
    postCreated: {
      subscribe: () => pubsub.asyncIterator(['POST_CREATED']),
    },
    commentAdded: {
      subscribe: (_p, { postId }) => pubsub.asyncIterator(['COMMENT_ADDED']),
    },
  },
};

module.exports = { typeDefs, resolvers };
