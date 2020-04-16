/* eslint no-console: 0 */

 import Vue from 'vue/dist/vue.esm'
 import Hello from '../hello.vue'

 document.addEventListener('DOMContentLoaded', () => {
   const app = new Vue({
     el: '#app',
     components: { Hello },
     template: '<Hello/>',
   })
 })
