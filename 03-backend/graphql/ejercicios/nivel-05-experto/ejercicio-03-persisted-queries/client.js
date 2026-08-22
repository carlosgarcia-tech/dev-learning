import { ApolloClient, InMemoryCache, HttpLink, from } from '@apollo/client';
import { createPersistedQueryLink } from '@apollo/client/link/persisted-queries';

const persistedLink = createPersistedQueryLink({
  useGETForHashedQueries: true,
});

const httpLink = new HttpLink({ uri: '/graphql' });

const client = new ApolloClient({
  link: from([persistedLink, httpLink]),
  cache: new InMemoryCache(),
});

module.exports = { client };
