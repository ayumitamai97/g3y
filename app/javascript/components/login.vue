<template>
  <div>
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
          <button v-on:click='login' class='button'>Login</button>
        </div>
      </div>
    </div>

    <div>
      <div v-for='error in errors' :key='error'>
        <p>{{ error }}</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
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
  },
  methods: {
    async login(): Promise<void> {
      await this.setToken()

      if (authUtil.isAuthenticated()) {
        this.$router.push('/')
      } else {
        this.errors.push('Email or password is invalid')
      }
    },
  },
}
</script>
