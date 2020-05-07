<template>
  <div class='columns'>
    <section class='section column is-3 is-offset-1'>
      <div>
        <h1 class='title is-1'>
          <router-link to='/'>g3y</router-link>
        </h1>
      </div>
      <div>
        <div v-if='!isAuthenticated()'>
          <router-link to="/login">Login</router-link>
          <span> | </span>
          <router-link to="/signup">Signup</router-link>
        </div>
        <div v-if='isAuthenticated()'>
          <p>Logged in as {{ userName() }}</p>
          <a v-on:click='logout'>Logout</a>
        </div>
      </div>
    </section>
    <section class='section column is-four-fifths is-6'>
      <router-view></router-view>
    </section>
  </div>
</template>

<script lang='ts'>
import authUtil from '../src/authUtil.ts'

export default {
  name: 'app',
  created() {
    this.isAuthenticated = authUtil.isAuthenticated
  },
  methods: {
    userName() {
      return this.$store.state.user_name
    },
    logout(): void {
      localStorage.removeItem('access')
      localStorage.removeItem('accessExpiresAt')
      this.$router.push('/login')
    },
  },
}
</script>
