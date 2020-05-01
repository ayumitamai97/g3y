/* eslint no-new: 0 */

import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import { ApolloClient } from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context'
import { InMemoryCache } from 'apollo-cache-inmemory'
import VueApollo from 'vue-apollo'
import InfiniteLoading from 'vue-infinite-loading'
import App from '../components/app.vue'
import Home from '../components/home.vue'
import Login from '../components/login.vue'
import Signup from '../components/signup.vue'

document.addEventListener('DOMContentLoaded', () => {
  Vue.use(VueRouter)
  Vue.use(VueApollo)
  Vue.use(InfiniteLoading)

  const routes = [
    { path: '/', component: Home },
    { path: '/login', component: Login },
    { path: '/signup', component: Signup },
  ]

  const router = new VueRouter({ mode: 'history', routes })

  // Apollo
  // ref. https://github.com/vuejs/vue-apollo/issues/144#issuecomment-522945282
  const httpLink = createHttpLink({ uri: `${process.env.HOST}/graphql` })
  const authLink = setContext((_, { headers }) => {
    const token = localStorage.getItem('access')
    return {
      headers: {
        ...headers,
        authorization: token ? `Bearer ${token}` : '',
      },
    }
  })
  const cache = new InMemoryCache()
  const apolloClient = new ApolloClient({
    link: authLink.concat(httpLink),
    cache,
  })
  const apolloProvider = new VueApollo({ defaultClient: apolloClient })

  new Vue({
    el: '#app',
    components: { App },
    template: '<App/>',
    router,
    apolloProvider,
    render: (h) => h(App),
  })
})
