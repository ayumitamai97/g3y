/* eslint no-new: 0 */

import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import { ApolloClient } from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { InMemoryCache } from 'apollo-cache-inmemory'
import VueApollo from 'vue-apollo'
import App from '../components/app.vue'

document.addEventListener('DOMContentLoaded', () => {
  Vue.use(VueRouter)
  Vue.use(VueApollo)

  const Foo = { template: '<div>foo</div>' }
  const Bar = { template: '<div>bar</div>' }

  const routes = [
    { path: '/foo', component: Foo },
    { path: '/bar', component: Bar },
  ]

  const router = new VueRouter({
    mode: 'history',
    routes,
  })

  const httpLink = createHttpLink({
    // TODO: environmental variable
    uri: 'http://localhost:3000/graphql',
  })
  const cache = new InMemoryCache()
  const apolloClient = new ApolloClient({
    link: httpLink,
    cache,
  })

  const apolloProvider = new VueApollo({
    defaultClient: apolloClient,
  })

  new Vue({
    el: '#app',
    components: { App },
    template: '<App/>',
    router,
    apolloProvider,
    render: h => h(App),
  })
})
