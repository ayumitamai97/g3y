<template>
  <div class='p-login'>
    <div class='p-login__form'>
      <div>
        <label for='email'>Email</label>
        <input type="email" v-model="user.email">
      </div>
      <div>
        <label for='password'>Password</label>
        <input type="password" v-model="user.password">
      </div>

      <button v-on:click="login">Login</button>
    </div>

    <div class='p-login__errors'>
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
