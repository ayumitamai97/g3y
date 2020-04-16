/* eslint no-new: 0 */

import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import App from '../components/app.vue'

document.addEventListener('DOMContentLoaded', () => {
  Vue.use(VueRouter)

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

  new Vue({
    el: '#app',
    components: { App },
    template: '<App/>',
    router,
  })
})
