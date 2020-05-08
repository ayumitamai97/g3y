/* eslint no-new: 0 */

import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import { ApolloClient } from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context'
import { InMemoryCache } from 'apollo-cache-inmemory'
import VueApollo from 'vue-apollo'
import InfiniteLoading from 'vue-infinite-loading'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import App from '../components/app.vue'
import Home from '../components/home.vue'
import Login from '../components/login.vue'
import Signup from '../components/signup.vue'
import Explore from '../components/explore.vue'

document.addEventListener('DOMContentLoaded', () => {
  Vue.use(VueRouter)
  Vue.use(VueApollo)
  Vue.use(InfiniteLoading)
  Vue.use(Vuex)

  const routes = [
    { path: '/', component: Home },
    { path: '/login', component: Login },
    { path: '/signup', component: Signup },
    { path: '/explore', component: Explore },
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
        authorization: token || '',
      },
    }
  })
  const cache = new InMemoryCache()
  const apolloClient = new ApolloClient({
    link: authLink.concat(httpLink),
    cache,
  })
  const apolloProvider = new VueApollo({ defaultClient: apolloClient })

  // Vuex
  const store = new Vuex.Store({
    state: {
      user_name: '',
      postsUpdatedDatetime: Date.now(),
    },
    mutations: {
      setUserName(state, userName): void {
        // TODO: camel calse !!
        state.user_name = userName
      },
      postsUpdated(state, datetime): void {
        state.postsUpdatedDatetime = datetime
      },
    },
    plugins: [createPersistedState()],
  })

  // FontAwesome
  Vue.component('font-awesome-icon', FontAwesomeIcon)
  Vue.config.productionTip = false

  new Vue({
    el: '#app',
    components: { App },
    template: '<App/>',
    router,
    store,
    apolloProvider,
    render: (h) => h(App),
  })
})
