/* eslint no-new: 0 */
import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import Hello from '../hello.vue'

document.addEventListener('DOMContentLoaded', () => {
  Vue.use(VueRouter)

  new Vue({
    el: '#app',
    components: { Hello },
    template: '<Hello/>',
  })
})
