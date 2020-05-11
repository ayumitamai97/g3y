<template>
  <div>
    <div class='notification is-danger' v-if='errors.length > 0'>
      <button class='delete' @click='closeError'></button>
      <div v-for='error in errors' :key='error'>
        <p>{{ error }}</p>
      </div>
    </div>

    <div>
      <div class='field'>
        <div class='control'>
          <input type="email" v-model='user.email'
           placeholder='Email' class='input'>
        </div>
      </div>
      <div class='field'>
        <div class='control'>
          <input type="password" v-model='user.password'
           placeholder='Password' class='input'>
        </div>
      </div>

      <div class='field'>
        <div class='control'>
          <button @click='login' class='button'>Login</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import jwtDecode from 'jwt-decode'
import util from '../src/util.ts'
import authUtil from '../src/authUtil.ts'

export default {
  data() {
    return {
      user: { name: '', email: '', password: '' },
      errors: [],
    }
  },
  created() {
    this.setToken = authUtil.setToken.bind(this)
    this.authenticateUser = authUtil.authenticateUser.bind(this)
    this.closeError = util.closeError.bind(this)
  },
  methods: {
    async login(): Promise<void> {
      await this.setToken()

      if (authUtil.isAuthenticated()) {
        this.$store.commit('setUserName', jwtDecode(localStorage.getItem('access')).user_name)
        this.$router.push('/')
      } else {
        this.errors = ['Email or password is invalid']
      }
    },
  },
}
</script>
