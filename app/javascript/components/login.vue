<template>
  <div class='mt-20'>
    <errors :errors='errors' />

    <div>
      <div class='field'>
        <div class='control'>
          <input
            v-model='user.email'
            type='email'
            placeholder='Email'
            class='input is-rounded'
          >
        </div>
      </div>
      <div class='field'>
        <div class='control'>
          <input
            v-model='user.password'
            type='password'
            placeholder='Password'
            class='input is-rounded'
          >
        </div>
      </div>

      <div class='field'>
        <div class='control'>
          <button
            class='button is-rounded is-primary has-text-weight-bold'
            @click='login'
          >
            Login
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import jwtDecode from 'jwt-decode'
import util from '../src/util.ts'
import authUtil from '../src/authUtil.ts'
import Errors from './errors.vue'

export default {
  components: { Errors },
  data(): Object {
    return {
      user: { name: '', email: '', password: '' },
      errors: [],
    }
  },
  created(): void {
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
