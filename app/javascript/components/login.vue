<template>
  <div class='p-login'>
    <input type="email" v-model="user.email">
    <input type="password" v-model="user.password">
    <button v-on:click="login">Login</button>
  </div>
</template>

<script lang="ts">
import gql from 'graphql-tag'

export default {
  data() {
    return {
      user: {},
    }
  },
  methods: {
    async login(): Promise<void> {
      await this.setToken()
    },
    async setToken(): Promise<void> {
      const { data } = await this.authenticateUser()
      localStorage.setItem('access', data.authenticateUser.access)
      localStorage.setItem('accessExpiresAt', data.authenticateUser.accessExpiresAt)
    },
    async authenticateUser(): Promise<Object> {
      return this.$apollo.mutate({
        mutation: gql`mutation authenticateUser ($email: String!, $password: String!) {
          authenticateUser(input: { email: $email, password: $password }) {
            access
            accessExpiresAt
          }
        }`,
        variables: {
          email: this.user.email,
          password: this.user.password,
        },
      })
    },
  },
}
</script>
