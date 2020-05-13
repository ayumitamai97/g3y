<template>
  <div>
    <div class='notification is-danger' v-if='errors.length > 0'>
      <button class='delete'></button>
      <div v-for='error in errors' :key='error'>
        <p>{{ error }}</p>
      </div>
    </div>

    <div>
      <div class='field'>
        <div class='control'>
          <input type="text" v-model='user.name'
           placeholder='Username' class='input'>
        </div>
      </div>

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
          <button @click='signup' class='button'>Signup</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import gql from 'graphql-tag'
import jwtDecode from 'jwt-decode'
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
          this.$store.commit('setUserName', jwtDecode(localStorage.getItem('access')).user_name)
          this.$router.push('/')
        }
      } else if (data.createUser.errors.length > 0) {
        const errors = []
        data.createUser.errors.forEach((err) => errors.push(err))
        this.errors = errors
      }
    },
  },
}
</script>
