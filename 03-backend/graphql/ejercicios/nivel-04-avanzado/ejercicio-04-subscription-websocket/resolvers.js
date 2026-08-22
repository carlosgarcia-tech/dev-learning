const { PubSub } = require('graphql-subscriptions');
const pubsub = new PubSub();
const POST_ADDED = 'POST_ADDED';

const resolvers = {
  Subscription: {
    postAdded: {
      subscribe: () => pubsub.asyncIterator([POST_ADDED]),
    },
  },
  Mutation: {
    createPost: async (parent, args, context) => {
      const post = await context.db.posts.create({ data: args.input });
      pubsub.publish(POST_ADDED, { postAdded: post });
      return post;
    },
  },
};

module.exports = { resolvers, pubsub, POST_ADDED };
