<template>
  <div>
    <div v-if='!isAuthenticated()'>
      <router-link to="/login">Login</router-link>
      <router-link to="/signup">Signup</router-link>
    </div>
    <div v-if='isAuthenticated()'>
      <!-- TODO -->
      <p>Logged in as hogehoge</p>
      <button v-on:click='logout'>Logout</button>
    </div>
    <router-view></router-view>
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
    logout(): void {
      localStorage.removeItem('access')
      localStorage.removeItem('accessExpiresAt')
      this.$router.push('/login')
    },
  },
}
</script>
