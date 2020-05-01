<template>
  <div class='p-signup'>
    <div class='p-signup__form'>
      <div>
        <label for="email">Email</label>
        <input type="email" name='email' v-model="user.email">
      </div>
      <div>
        <label for="name">Username</label>
        <input type="text" name='name' v-model="user.name">
      </div>
      <div>
        <label for="password">Password</label>
        <input type="password" name='password' v-model="user.password">
      </div>

      <button v-on:click="signup">Signup</button>
    </div>

    <div class='p-signup__errors'>
      <div v-for='error in errors' :key='error'>
        <p>{{ error }}</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import gql from 'graphql-tag'
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
    async signup(): Promise<void> {
      const request = this.$apollo.mutate({
        mutation: gql`mutation createUser ($name: String!, $email: String!, $password: String!) {
          createUser(input: { name: $name, email: $email, password: $password }) {
            user {
              name
              email
            }
            errors
          }
        }`,
        variables: {
          name: this.user.name,
          email: this.user.email,
          password: this.user.password,
        },
      })
      const { data } = await request

      if (data.createUser.user) {
        await this.setToken()

        if (authUtil.isAuthenticated()) {
          this.$router.push('/')
        }
      } else if (data.createUser.errors.length > 0) {
        data.createUser.errors.forEach((err) => this.errors.push(err))
      }
    },
  },
}
</script>
