<template>
  <div class='mt-20'>
    <errors :errors='errors' />

    <div>
      <div class='field'>
        <div class='control'>
          <input
            v-model='user.name'
            type='text'
            placeholder='Username'
            class='input is-rounded'
          >
        </div>
      </div>

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
            @click='signup'
          >
            Signup
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import gql from 'graphql-tag'
import jwtDecode from 'jwt-decode'
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
